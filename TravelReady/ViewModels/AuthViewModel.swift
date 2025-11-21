import Foundation
import SwiftUI
import GoogleSignIn
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var user: GIDGoogleUser?
    @Published var errorMessage: String?

    private let authService = GoogleAuthService.shared

    var isSignedIn: Bool { user != nil }
    var displayName: String? { user?.profile?.name ?? user?.profile?.email }
    var email: String? { user?.profile?.email }
    
    var firstName: String {
        let full = displayName ?? ""
        return full.split(separator: " ").first.map(String.init) ?? full
    }

    func signIn() async {
        guard let presenter = UIApplication.topViewController() else {
            errorMessage = "Unable to find a presenter for sign-in."
            return
        }

        do {
            let signedInUser = try await authService.signIn(presenting: presenter)
            user = signedInUser
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            print("Google sign-in failed: \(error)")
        }
    }

    func restoreSession() async {
        do {
            if let restoredUser = try await authService.restorePreviousSignIn() {
                user = restoredUser
            }
        } catch {
            // Non-fatal, user can sign in manually.
            print("No prior Google session restored: \(error)")
        }
    }

    func signOut() {
        authService.signOut()
        user = nil
        errorMessage = nil
    }
}
