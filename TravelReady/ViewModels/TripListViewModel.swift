import Foundation
import Combine
import SwiftData

final class TripListViewModel: ObservableObject {
    @Published var trips: [Trip] = []

    private var cancellables = Set<AnyCancellable>()
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadTrips()
    }

    func loadTrips() {
        let descriptor = FetchDescriptor<Trip>(
            sortBy: [SortDescriptor(\.departureDate, order: .forward)]
        )

        do {
            trips = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching trips: \(error)")
            trips = []
        }
    }

    func addSampleTrip() {
        let now = Date()
        let returnDate = Calendar.current.date(byAdding: .day, value: 7, to: now) ?? now

        let trip = Trip(
            name: "Sample Trip",
            origin: "Phoenix",
            destination: "San Francisco",
            travelType: .leisure,
            travelMode: .air,
            currentPhase: .pre,
            departureDate: now,
            returnDate: returnDate,
            adultCount: 2,
            childCount: 1,
            infantCount: 0,
            weatherSummary: "Mild, breezy"
           
        )

        modelContext.insert(trip)

        do {
            try modelContext.save()
            loadTrips()
        } catch {
            print("Failed to save sample trip: \(error)")
        }
    }

    func deleteTrips(at offsets: IndexSet) {
        offsets.map { trips[$0] }.forEach { modelContext.delete($0) }
        do {
            try modelContext.save()
            loadTrips()
        } catch {
            print("Failed to delete trips: \(error)")
        }
    }
}
