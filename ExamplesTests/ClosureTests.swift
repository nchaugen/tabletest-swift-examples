import Foundation
import TableTest
import Testing
@testable import Examples

struct ClosureTests {
    /// A cell names an enum case by its case name, not by its raw value.
    @TableTest("""
        Closure  | Fresh days?
        cork     | 3
        screwCap | 5
        glass    | 5
        """)
    func keepsAnOpenedBottleFresh(closure: Closure, freshDays: Int) {
        #expect(closure.freshDays == freshDays)
    }

    /// A date is `2026-03-14`, at midnight UTC. A date and time names its zone.
    @TableTest("""
        Scenario                | Closure  | Opened     | Checked                   | Fresh?
        Cork on the third day   | cork     | 2026-03-14 | 2026-03-17                | true
        Cork on the fourth day  | cork     | 2026-03-14 | 2026-03-18                | false
        Screw cap, late evening | screwCap | 2026-03-14 | 2026-03-19T00:00:00+01:00 | true
        Screw cap, next morning | screwCap | 2026-03-14 | 2026-03-19T09:00:00Z      | false
        """)
    func staysFreshForItsDays(closure: Closure, opened: Date, checked: Date, fresh: Bool) {
        #expect(closure.isFresh(opened: opened, at: checked) == fresh)
    }
}
