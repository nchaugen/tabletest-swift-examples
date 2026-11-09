import Foundation

/// How a bottle is closed. A table names a case by its raw value, `screw cap`.
nonisolated enum Closure: String, Codable, CaseIterable {
    case cork
    case screwCap = "screw cap"
    case glass

    /// The days an opened bottle keeps fresh under this closure.
    var freshDays: Int {
        self == .cork ? 3 : 5
    }

    /// Whether a bottle opened at one time is still fresh at another.
    func isFresh(opened: Date, at time: Date) -> Bool {
        time.timeIntervalSince(opened) <= Double(freshDays) * 24 * 60 * 60
    }
}
