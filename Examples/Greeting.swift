/// Makes the greeting the app shows. Main-actor isolated through the target's
/// default isolation, so a test must run on the main actor to call it.
struct Greeting {
    static func text(for name: String, hour: Int) -> String {
        let part = switch hour {
        case 5..<12: "Good morning"
        case 12..<18: "Good afternoon"
        default: "Good evening"
        }
        return name.isEmpty ? part : "\(part), \(name)"
    }
}
