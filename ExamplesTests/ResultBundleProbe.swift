#if PROBE_XCRESULT
import TableTest
import Testing
@testable import Examples

/// Tables that fail, skip and collide on purpose, for the export check.
@Suite("Result bundle probe")
struct ResultBundleProbe {
    /// Both rows check 2004, so their cases share a name.
    ///
    /// The second row fails on purpose.
    @TableTest("Leap year result bundle probe", .serialized, table: """
        Scenario         | Year               | Leap?
        Check leap years | {2004, 1900, 2000} | true
        Check leap years | {2004}             | false
        """)
    func leapYear(year: Int, leap: Bool) throws {
        if year == 2000 {
            try Test.cancel("Skip this value-set case on purpose")
        }
        #expect(Year(year).isLeap == leap)
    }

    @TableTest("Names collide within one row", table: """
        Values            | Count?
        {[a, b], ["a, b"]} | 2
        """)
    func sameNameWithinRow(values: [String], count: Int) {
        #expect(values.count == count)
    }

    /// A disabled table still has a page.
    @TableTest("Disabled table", .disabled("Disabled on purpose"), table: """
        Value
        1
        """)
    func disabledTable(value: Int) {
        Issue.record("Disabled case ran")
    }
}
#endif
