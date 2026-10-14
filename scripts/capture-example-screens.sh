#!/usr/bin/env bash
# Captures screenshots of the ChartGallery example app running on an iPhone simulator.
#
# RenderTests draws the charts off screen; this script shows them in the real app instead:
# it builds and installs ChartGallery, opens each screen with `-sample <case name>`, and takes
# a simulator screenshot in light and dark appearance with a fixed status bar. The live data
# screen shows whatever the ticker holds at that moment.
#
# Usage: scripts/capture-example-screens.sh [simulator name or UDID] [sample ...]
# Without a simulator it uses the first available iPhone; without samples it captures
# timeSeries and liveData. Output: docs/images/example-<sample>-<appearance>.png
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
shift || true
samples=("$@")
if [[ ${#samples[@]} -eq 0 ]]; then
  samples=(timeSeries liveData)
fi

bundle_id="io.github.muhittincamdali.ChartGallery"
output_dir="$repo_root/docs/images"
build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT
mkdir -p "$output_dir"

destination="platform=iOS Simulator,name=$device"
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  destination="platform=iOS Simulator,id=$device"
fi

echo "Building ChartGallery for '$device'"
xcodebuild build \
  -project "$repo_root/Examples/ChartGallery/ChartGallery.xcodeproj" \
  -scheme ChartGallery \
  -destination "$destination" \
  -derivedDataPath "$build_dir" \
  -quiet
app="$(find "$build_dir/Build/Products" -maxdepth 2 -name 'ChartGallery.app' -path '*iphonesimulator*' | head -1)"

xcrun simctl boot "$device" 2>/dev/null || true
xcrun simctl bootstatus "$device" -b >/dev/null
xcrun simctl status_bar "$device" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 --operatorName ""
xcrun simctl install "$device" "$app"

for appearance in light dark; do
  xcrun simctl ui "$device" appearance "$appearance"
  for sample in "${samples[@]}"; do
    xcrun simctl launch --terminate-running-process "$device" "$bundle_id" -sample "$sample" >/dev/null
    sleep 5 # let the navigation push, the first layout and a few live updates finish
    file="$output_dir/example-$sample-$appearance.png"
    xcrun simctl io "$device" screenshot --type=png "$file" >/dev/null 2>&1
    # Half the width of an iPhone 17 Pro screenshot keeps the README light; the navigation
    # bar and the charts fit in the top 760 pixels of that.
    sips --resampleWidth 603 "$file" >/dev/null
    sips --cropToHeightWidth 760 603 --cropOffset 0 0 "$file" >/dev/null
    echo "$file"
  done
done

xcrun simctl status_bar "$device" clear
