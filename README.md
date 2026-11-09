# TableTest for Swift — examples

An Xcode project that uses [tabletest-swift](../tabletest-swift) through a local
package reference. It is both a set of examples and the local test bed for
developing TableTest for Swift, as `tabletest-examples` is for the JVM.

The app target uses MainActor default isolation and the test target runs hosted in
the app, the setup of a typical SwiftUI app.

## Run the tests

```sh
xcodebuild test -project Examples.xcodeproj -scheme Examples \
  -destination 'platform=macOS' -skipMacroValidation
```

Add `'SWIFT_ACTIVE_COMPILATION_CONDITIONS=DEBUG PROBE_FAILING'` to also run the
probe tables that fail on purpose.

## License

Licensed under the [Apache License, Version 2.0](LICENSE), as the other TableTest products are.
