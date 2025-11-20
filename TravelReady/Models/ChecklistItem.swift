// Models/ChecklistItem.swift

import Foundation
import SwiftData

@Model
final class ChecklistItem {
    @Attribute(.unique) var id: UUID
    var tripID: UUID
    var title: String

    // Persisted as raw string to keep it simple for SwiftData
    var phaseRaw: String
    var isCompleted: Bool

    // Convenience computed property used by the ViewModel / views
    var phase: TripPhase {
        get { TripPhase(rawValue: phaseRaw) ?? .pre }
        set { phaseRaw = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        tripID: UUID,
        title: String,
        phase: TripPhase = .pre,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.tripID = tripID
        self.title = title
        self.phaseRaw = phase.rawValue
        self.isCompleted = isCompleted
    }
}
