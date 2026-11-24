# TableTest for Swift — examples

An Xcode project that uses [tabletest-swift](https://github.com/nchaugen/tabletest-swift) as a
package from GitHub. It is both a set of examples and the test bed for developing TableTest for
Swift, as [tabletest-examples](https://github.com/nchaugen/tabletest-examples) is for the JVM.

The app target uses MainActor default isolation and the test target runs hosted in
the app, the setup of a typical SwiftUI app.

## Run the tests

```sh
xcodebuild test -project Examples.xcodeproj -scheme Examples \
  -destination 'platform=macOS' -skipMacroValidation
```

`-skipMacroValidation` is needed until you trust the `TableTestMacros` macro on your machine: in
Xcode, build the tests once and select **Trust & Enable**.

Add `'SWIFT_ACTIVE_COMPILATION_CONDITIONS=DEBUG PROBE_FAILING'` to also run the
probe tables that fail on purpose.

## Export a TableTest report from an Xcode result bundle

Enable `TABLETEST_REPORTING` in the test target to have each `@TableTest` table
attach its own manifest. The exporter works from this metadata and the Xcode
results. Run the example from the project directory with Xcode 27.2, the local
[tabletest-swift checkout](#test-a-local-tabletest-swift), and the
[TableTest Reporter CLI](https://github.com/nchaugen/tabletest-reporter) JAR.

```sh
mkdir -p .build
run=$(mktemp -d "$PWD/.build/xcresult-probe.XXXXXXXX")
xcodebuild test -project Examples.xcodeproj -scheme Examples \
  -destination 'platform=macOS' -skipMacroValidation \
  -resultBundlePath "$run/results.xcresult" \
  'SWIFT_ACTIVE_COMPILATION_CONDITIONS=DEBUG TABLETEST_REPORTING PROBE_XCRESULT'
```

`PROBE_XCRESULT` adds tables with duplicate display names, failures, and
skipped cases. With the probe enabled, `xcodebuild` exits with status 65 and
still writes the result bundle.

```sh
swift run --package-path ../tabletest-swift tabletest-export "$run/results.xcresult" "$run/export"
java -jar /path/to/tabletest-reporter-cli.jar \
  -f html -i "$run/export/yaml" -o "$run/report"
open "$run/report/index.html"
```

The exporter uses `xcresulttool export attachments`, `get test-results tests`,
and `get test-results test-details`. It joins each manifest to the test of its table
and matches their reflected row and case numbers. A case whose name repeats in
its table has its row and case number in its name, in Xcode and in the YAML.

`export/joined-results.json` includes the original and Xcode case names, the
device, the test-plan configuration, and the attempt number and outcome for
each case. The reporter generates a separate table page for each destination,
configuration, and attempt when a table has more than one. A successful retry
has its own page, so the first failure remains visible. The HTML describes
skipped or unrun cases alongside the table.

Include the companion tests in the selection for each destination and
configuration. An enclosing suite that skips its companion also prevents the
manifest from reaching the result bundle. The exporter accepts a bundle made
with `xcresulttool merge` when the public result tree can identify each run.
It accepts repeated copies of the same manifest and reports an error when
the metadata conflicts or when Xcode exposes indistinguishable attempts.

### Run the end-to-end check

From the examples checkout, run the check with Xcode, Python 3, Java 21+, and
the reporter JAR. The check stages a project that uses the sibling Swift
checkout, runs the probe, invokes `tabletest-export`, and verifies the HTML
and the case outcomes. It prints the directory with the results.

```sh
scripts/check-report-export.sh /path/to/tabletest-reporter-cli.jar
```

Pass the path to the Swift checkout as the second argument if it is elsewhere.

## Test a local tabletest-swift

To try changes to tabletest-swift before a release, drag the folder of your tabletest-swift
checkout into the project navigator of `Examples.xcodeproj`. Xcode then uses that folder in place
of the package from GitHub. Remove the folder from the navigator to use the released package
again. Do not commit the change to the project.

## License

Licensed under the [Apache License, Version 2.0](LICENSE), as the other TableTest products are.
