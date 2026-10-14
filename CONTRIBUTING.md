# Contributing

Thanks for taking the time to improve SwiftUI Data Visualization.

## Reporting bugs

Open an issue with:

- the chart and the initializer arguments you used,
- a small sample of the data that shows the problem (include `nan`, infinite or very large
  values if they are part of it),
- what you expected and what happened (a screenshot helps for visual bugs),
- platform and OS version (iOS simulator/device or macOS) and Xcode version.

## Pull requests

1. Fork the repository and branch from `master`.
2. Keep each pull request focused on one change.
3. Run the tests on both platforms:

    ```sh
    swift test
    xcodebuild test -scheme SwiftUIDataVisualization \
      -destination 'platform=iOS Simulator,name=iPhone 17'
    ```

4. If you change a computation (binning, quantiles, regression, downsampling, layout, the
   preparation a chart does before drawing), add or update a test in
   `Tests/SwiftUIDataVisualizationTests`. Keep such logic in value types or `nonisolated static`
   functions so it can be tested without rendering a view.
5. Charts draw data that comes from users and networks. New code must accept empty input,
   `nan`, infinity and values near `Double.greatestFiniteMagnitude` without trapping, must not
   convert an unchecked `Double` with `Int(_:)`, and must bound any allocation that depends on
   the input. Add a case to `ExtremeInputTests.swift` for each new computation.
6. If you change a README code sample, change the copy in
   `Examples/ChartGallery/ChartGallery/ReadmeSamples.swift` as well. That file is what gets
   compiled: by the example app, and by `swift test` through the symlink
   `Tests/SwiftUIDataVisualizationTests/ReadmeExamples.swift`. Build the app with:

    ```sh
    cd Examples/ChartGallery
    xcodebuild build -scheme ChartGallery -destination 'generic/platform=iOS Simulator'
    ```

7. If a change affects the screenshots, regenerate them with `scripts/generate-screenshots.sh`
   (and `scripts/capture-example-screens.sh` for the example app captures).
8. `README.md` has translations (`README.<language>.md`). Each one records the version of
   `README.md` it follows, and CI fails while a translation is behind. If you change `README.md`
   and cannot update the translations, say so in the pull request and they will be updated
   before it is merged.

## Code style

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- The package builds in the Swift 6 language mode; new code should not add warnings.
- Document public API with DocC comments (`///`); `xcodebuild docbuild` should pass with
  `OTHER_DOCC_FLAGS=--warnings-as-errors`.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `ci:`, `chore:`).

## License

By contributing you agree that your contributions are licensed under the MIT License.
