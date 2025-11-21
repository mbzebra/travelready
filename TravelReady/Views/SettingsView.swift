import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)

                        VStack(alignment: .leading) {
                            Text(authViewModel.displayName ?? "Unknown user")
                                .font(.headline)
                            if let email = authViewModel.email {
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    Button(role: .destructive) {
                        authViewModel.signOut()
                    } label: {
                        Text("Sign out")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
