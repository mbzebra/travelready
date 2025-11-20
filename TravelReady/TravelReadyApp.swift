import SwiftUI
import SwiftData

@main
struct TravelReadyApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            Trip.self,
            ChecklistItem.self,
            ChecklistCategory.self
        ])
    }
}
