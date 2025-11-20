import SwiftUI

struct TripListView: View {
    @ObservedObject var viewModel: TripListViewModel

    var body: some View {
        List {
            ForEach(viewModel.trips, id: \.id) { trip in
                NavigationLink {
                    TripDetailView(trip: trip)
                } label: {
                    TripRowView(trip: trip)
                }
            }
            .onDelete(perform: viewModel.deleteTrips)
        }
        .navigationTitle("TravelReady")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.addSampleTrip()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadTrips()
        }
    }
}

struct TripRowView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(trip.name)
                .font(.headline)
            Text("\(trip.origin) → \(trip.destination)")
                .font(.subheadline)

            HStack(spacing: 8) {
                Text(trip.travelType.displayName)
                    .font(.caption)
                    .padding(4)
                    .background(.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text(trip.currentPhase.displayName)
                    .font(.caption2)
                    .padding(4)
                    .background(.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }

            Text("\(formatted(date: trip.departureDate)) – \(formatted(date: trip.returnDate))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func formatted(date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
}
