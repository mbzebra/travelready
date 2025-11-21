import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 12) {
                Text("Welcome to TravelReady")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("Sign in with Google to sync your trips and keep your travel checklists up to date.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)

            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }

            GoogleSignInButton(action: {
                Task { await authViewModel.signIn() }
            })
            .frame(height: 52)
            .padding(.horizontal, 24)

            Spacer()

            Text("We only use your email to personalize your trips. You can sign out anytime in Settings.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 32)
    }
}
