// Views/RootView.swift
import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isSignedIn {
                TabView {
                    NavigationStack {
                        if let name = authViewModel.displayName {
                            Text("Hi \(authViewModel.firstName)")
                                    .font(.title.bold())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                        TripListView(
                            viewModel: TripListViewModel(modelContext: modelContext)
                        )
                    }
                    .tabItem {
                        Label("Trips", systemImage: "suitcase.rolling")
                    }

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                    
                }
            } else {
                LoginView()
            }
        }
        .task {
            await authViewModel.restoreSession()
        }
    }
}
