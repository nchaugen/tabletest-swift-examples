import TableTest
import Testing
@testable import Examples

/// Calls main-actor code from a table. The generated test runs on the main actor because the
/// suite is `@MainActor`.
@MainActor
struct GreetingTests {
    @TableTest("""
        Scenario  | Name | Hour | Greeting?
        Morning   | Ada  | 9    | Good morning, Ada
        Afternoon | Ada  | 14   | Good afternoon, Ada
        No name   | ''   | 22   | Good evening
        """)
    func greetsByTheHour(name: String, hour: Int, greeting: String) {
        #expect(Greeting.text(for: name, hour: hour) == greeting)
    }
}
