import TableTest
import Testing
@testable import Examples

struct YearTests {
    @TableTest("""
        Scenario                     | Year | Leap?
        Divisible by 4               | 2004 | true
        Not divisible by 4           | 2001 | false
        Divisible by 100, not by 400 | 1900 | false
        Divisible by 400             | 2000 | true
        """)
    func knowsALeapYear(year: Int, leap: Bool) {
        #expect(Year(year).isLeap == leap)
    }

    @TableTest("Leap years without a scenario column", table: """
        Year | Leap?
        2024 | true
        2023 | false
        """)
    func knowsALeapYearByRow(year: Int, leap: Bool) {
        #expect(Year(year).isLeap == leap)
    }

    #if PROBE_FAILING
    /// Fails on purpose: one cell does not convert, and one row expects the wrong answer.
    @TableTest("""
        Scenario       | Year | Leap?
        Divisible by 4 | 2004 | true
        Typo           | 200x | false
        Wrong answer   | 1900 | true
        """)
    func probeFailingRows(year: Int, leap: Bool) {
        #expect(Year(year).isLeap == leap)
    }
    #endif
}
