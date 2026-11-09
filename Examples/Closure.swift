import Foundation

/// How a bottle is closed. The raw values are the keys the app stores; a table names a case as
/// Swift code does, `screwCap`.
nonisolated enum Closure: String, Codable, CaseIterable {
    case cork
    case screwCap = "screw_cap"
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
