#!/usr/bin/env bash
# Renders the README screenshots on an iOS simulator.
#
# The images come from Tests/SwiftUIDataVisualizationTests/RenderTests.swift, which draws the
# README samples (Examples/ChartGallery/ChartGallery/ReadmeSamples.swift) with ImageRenderer
# in light and dark appearance.
#
# Usage: scripts/generate-screenshots.sh [simulator name or UDID]
# Without an argument it uses the first available iPhone simulator. Output: docs/images/
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
device="${1:-}"
if [[ -z "$device" ]]; then
  device="$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')"
fi
if [[ -z "$device" ]]; then
  echo "No available iPhone simulator found." >&2
  exit 1
fi

destination="platform=iOS Simulator,name=$device"
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  destination="platform=iOS Simulator,id=$device"
fi

output_dir="$repo_root/docs/images"
mkdir -p "$output_dir"
echo "Rendering on '$device' into $output_dir"

cd "$repo_root"
# Variables prefixed with TEST_RUNNER_ are forwarded to the test process without the prefix.
TEST_RUNNER_SCREENSHOT_DIR="$output_dir" xcodebuild test \
  -scheme SwiftUIDataVisualization \
  -destination "$destination" \
  -only-testing:SwiftUIDataVisualizationTests/RenderTests \
  -quiet

ls -1 "$output_dir"
