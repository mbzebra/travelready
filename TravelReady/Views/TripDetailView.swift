import SwiftUI
import SwiftData
import Combine   // needed for ObservableObject / @Published in ViewModelHolder

struct TripDetailView: View {
    @Environment(\.modelContext) private var modelContext

    let trip: Trip
    @StateObject private var viewModelHolder = ViewModelHolder()

    var body: some View {
        // configure the holder once we have modelContext and trip
        viewModelHolder.configureIfNeeded(trip: trip, modelContext: modelContext)

        return Group {
            if let viewModel = viewModelHolder.viewModel {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        tripHeader(trip: viewModel.trip)

                        ForEach(TripPhase.allCases) { phase in
                            if let items = viewModel.itemsByPhase[phase],
                               !items.isEmpty {

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(phase.displayName)
                                        .font(.headline)

                                    ForEach(items, id: \.id) { item in
                                        ChecklistItemRow(
                                            item: item,
                                            toggleCompletion: {
                                                viewModel.toggleCompletion(for: item)
                                            }
                                        )
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }

                        Button("Add quick pre-travel item") {
                            viewModel.addChecklistItem(
                                title: "Sample item",
                                phase: .pre
                            )
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 16)
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    @ViewBuilder
    private func tripHeader(trip: Trip) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(trip.origin) → \(trip.destination)")
                .font(.title3)
                .bold()

            Text("\(trip.travelType.displayName) • \(trip.travelMode.displayName)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Phase: \(trip.currentPhase.displayName)")
                .font(.subheadline)

            if let summary = trip.weatherSummary, !summary.isEmpty {
                Text("Weather: \(summary)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - ViewModel holder so we can use @StateObject with modelContext

private final class ViewModelHolder: ObservableObject {
    @Published var viewModel: TripDetailViewModel?

    func configureIfNeeded(trip: Trip, modelContext: ModelContext) {
        if viewModel == nil {
            viewModel = TripDetailViewModel(trip: trip, modelContext: modelContext)
        }
    }
}

// MARK: - Row view

struct ChecklistItemRow: View {
    let item: ChecklistItem
    let toggleCompletion: () -> Void

    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .strikethrough(item.isCompleted, color: .primary)
            }

            Spacer()

            Text(item.phase.displayName)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}

