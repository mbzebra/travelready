import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct TravelReadyApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .onOpenURL { url in
                    _ = GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(for: [
            Trip.self,
            ChecklistItem.self,
            ChecklistCategory.self
        ])
    }
}
