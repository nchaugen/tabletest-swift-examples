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

## Test a local tabletest-swift

To try changes to tabletest-swift before a release, drag the folder of your tabletest-swift
checkout into the project navigator of `Examples.xcodeproj`. Xcode then uses that folder in place
of the package from GitHub. Remove the folder from the navigator to use the released package
again. Do not commit the change to the project.

## License

Licensed under the [Apache License, Version 2.0](LICENSE), as the other TableTest products are.
