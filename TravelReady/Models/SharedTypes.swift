import Foundation

enum TravelType: String, Codable, CaseIterable, Identifiable {
    case business, leisure, adventure, family, backpacking

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .business: return "Business"
        case .leisure: return "Leisure"
        case .adventure: return "Adventure"
        case .family: return "Family"
        case .backpacking: return "Backpacking"
        }
    }
}

enum TravelMode: String, Codable, CaseIterable, Identifiable {
    case air, car, train, cruise, multiModal

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .air: return "Air"
        case .car: return "Car"
        case .train: return "Train"
        case .cruise: return "Cruise"
        case .multiModal: return "Multi-modal"
        }
    }
}

enum TripPhase: String, Codable, CaseIterable, Identifiable {
    case pre
    case inTravel
    case end
    case post

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pre: return "Pre-Travel"
        case .inTravel: return "In-Travel"
        case .end: return "End-Travel"
        case .post: return "Post-Travel"
        }
    }
}


extension TripPhase {
    static func fromAPI(_ value: String) -> TripPhase {
        switch value.uppercased() {
        case "PRE_TRAVEL": return .pre
        case "IN_TRAVEL":  return .inTravel
        case "END_TRAVEL": return .end
        case "POST_TRAVEL": return .post
        default: return .pre
        }
    }
}
