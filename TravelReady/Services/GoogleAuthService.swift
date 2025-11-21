import Foundation
import UIKit
import GoogleSignIn

enum AuthServiceError: LocalizedError {
    case missingClientID

    var errorDescription: String? {
        switch self {
        case .missingClientID:
            return "Google client ID is missing. Add GOOGLE_CLIENT_ID to Info.plist."
        }
    }
}

/// Thin wrapper around GoogleSignIn so the rest of the app stays framework-agnostic.
@MainActor
final class GoogleAuthService {
    static let shared = GoogleAuthService()

    private let clientID: String?

    private init() {
        clientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String
    }

    private func configureClient() throws {
        guard let clientID else { throw AuthServiceError.missingClientID }

        if GIDSignIn.sharedInstance.configuration == nil {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        }
    }

    func signIn(presenting viewController: UIViewController) async throws -> GIDGoogleUser {
        try configureClient()
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        return result.user
    }

    func restorePreviousSignIn() async throws -> GIDGoogleUser? {
        try configureClient()
        return try await GIDSignIn.sharedInstance.restorePreviousSignIn()
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
