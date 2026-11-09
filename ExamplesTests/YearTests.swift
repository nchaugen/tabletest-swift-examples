import TableTest
import Testing
@testable import Examples

struct YearTests {
    @TableTest("""
        year | leap
        2004 | true
        2001 | false
        1900 | false
        2000 | true
        """)
    func knowsALeapYear(year: Int, leap: Bool) {
        #expect(Year(year).isLeap == leap)
    }

    #if PROBE_FAILING
    @TableTest("""
        year | leap
        2004 | true
        200x | false
        1900 | true
        """)
    func probeFailingRows(year: Int, leap: Bool) {
        #expect(Year(year).isLeap == leap)
    }
    #endif
}
