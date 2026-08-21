import Foundation

enum LumenSlot: String, Codable, CaseIterable, Identifiable, Sendable {
    case firstLight
    case midday
    case evening
    case nibble

    var id: String { rawValue }

    var title: String {
        switch self {
        case .firstLight: "First Light"
        case .midday: "Midday"
        case .evening: "Evening"
        case .nibble: "Nibble"
        }
    }

    var allowsPlan: Bool { self != .nibble }

    var artName: String {
        switch self {
        case .firstLight: "SlotFirstLight"
        case .midday: "SlotMidday"
        case .evening: "SlotEvening"
        case .nibble: "SlotNibble"
        }
    }
}
