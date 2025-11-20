// ViewModels/TripDetailViewModel.swift

import Foundation
import Combine          // ← THIS is the key missing import
import SwiftData

final class TripDetailViewModel: ObservableObject {
    @Published var trip: Trip
    @Published private(set) var items: [ChecklistItem] = []

    private let modelContext: ModelContext

    init(trip: Trip, modelContext: ModelContext) {
        self.trip = trip
        self.modelContext = modelContext
        loadItems()
    }

    // MARK: - Loading

    func loadItems() {
        do {
            let allItems = try modelContext.fetch(FetchDescriptor<ChecklistItem>())
            items = allItems.filter { $0.tripID == trip.id }
        } catch {
            print("Failed to fetch checklist items: \(error)")
            items = []
        }
    }

    // Grouped by phase for the UI
    var itemsByPhase: [TripPhase: [ChecklistItem]] {
        Dictionary(grouping: items, by: { $0.phase })
    }

    // MARK: - Mutations

    func addChecklistItem(title: String, phase: TripPhase) {
        let item = ChecklistItem(
            tripID: trip.id,
            title: title,
            phase: phase,
            isCompleted: false
        )
        modelContext.insert(item)
        saveAndReload()
    }

    func toggleCompletion(for item: ChecklistItem) {
        item.isCompleted.toggle()
        saveAndReload()
    }

    // MARK: - Helpers

    private func saveAndReload() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save checklist changes: \(error)")
        }
        loadItems()
    }
}
