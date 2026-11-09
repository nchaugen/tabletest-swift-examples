/// When a wine is ready to drink. A table names a case as Swift code does: `now`,
/// `from(year: 2028)`, `between(2025, 2030)`.
nonisolated enum Readiness: Codable, Equatable {
    case now
    case from(year: Int)
    case between(Int, Int)

    func allows(_ year: Int) -> Bool {
        switch self {
        case .now: true
        case let .from(first): year >= first
        case let .between(first, last): (first...last).contains(year)
        }
    }
}
