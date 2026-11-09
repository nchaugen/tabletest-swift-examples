import TableTest
import Testing
@testable import Examples

/// Calls main-actor code from a table. Probes whether the generated test runs on
/// the main actor when the suite is `@MainActor`.
@MainActor
struct GreetingTests {
    @TableTest("""
        name  | hour | greeting
        Ada   | 9    | Good morning, Ada
        Ada   | 14   | Good afternoon, Ada
              | 22   | Good evening
        """)
    func greetsByTheHour(name: String, hour: Int, greeting: String) {
        #expect(Greeting.text(for: name, hour: hour) == greeting)
    }
}
