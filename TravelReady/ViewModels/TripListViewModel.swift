import Foundation
import Combine
import SwiftData

@MainActor
final class TripListViewModel: ObservableObject {
    @Published var trips: [Trip] = []

    private var cancellables = Set<AnyCancellable>()
    private let modelContext: ModelContext
    private let apiService = TravelReadyAPIService.shared

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
        // (keep your existing sample-trip code if you like)
    }

    func deleteTrips(at offsets: IndexSet) {
        offsets.map { trips[$0] }.forEach { modelContext.delete($0) }
        try? modelContext.save()
        loadTrips()
    }

    // NEW: sync with API
    func syncFromAPI() async {
        do {
            let remoteTrips = try await apiService.fetchTrips(limit: 20, offset: 0)

            // Very naive merge: if apiId exists, skip; otherwise insert new Trip
            for dto in remoteTrips {
                if !trips.contains(where: { $0.apiId == dto.id }) {
                    let trip = Trip(
                        name: dto.name,
                        origin: dto.origin,
                        destination: dto.destination,
                        travelType: TravelType(rawValue: dto.travelType) ?? .leisure,
                        travelMode: .air, // until API sends a real mode
                        currentPhase: TripPhase.fromAPI(dto.phase),
                        departureDate: dto.startDate,
                        returnDate: dto.endDate,
                        adultCount: dto.travelerCount,
                        childCount: 0,
                        infantCount: 0,
                        weatherSummary: nil,
                        apiId: dto.id
                    )
                    modelContext.insert(trip)
                }
            }

            try? modelContext.save()
            loadTrips()
        } catch {
            print("Failed to sync from API: \(error)")
        }
    }
}
