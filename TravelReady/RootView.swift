// Views/RootView.swift
import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            NavigationStack {
                TripListView(
                    viewModel: TripListViewModel(modelContext: modelContext)
                )
            }
            .tabItem {
                Label("Trips", systemImage: "suitcase.rolling")
            }

            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
