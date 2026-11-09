import TableTest
import Testing
@testable import Examples

struct ReadinessTests {
    /// A cell spells an enum case with associated values as Swift code does. In a value set,
    /// a spelling with a comma or a colon is quoted.
    @TableTest("""
        Scenario         | Readiness                    | Year | Drink?
        Ready now        | now                          | 2026 | true
        Before its first | from(year: 2028)             | 2026 | false
        From its first   | from(year: 2028)             | 2028 | true
        Inside the span  | between(2025, 2030)          | 2027 | true
        After the span   | between(2025, 2030)          | 2031 | false
        Ready either way | {now, 'between(2025, 2030)'} | 2027 | true
        """)
    func allowsTheYearsItIsReady(readiness: Readiness, year: Int, drink: Bool) {
        #expect(readiness.allows(year) == drink)
    }
}
