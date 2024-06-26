//
//  SettingsView.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 6/2/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                        print("Signed Out")
                        print("showSignInView: \(showSignInView)")
                    } catch {
                        print("Couldn't sign out")
                        print(error) // Change for future
                    }
                }
            }
            
            if let user = viewModel.user {
                Section {
                    Text("User ID: \(user.userId)")
                    Text("Username: \(user.username)") // Assuming `username` is a property of `DBUser`
                }
            }
            
            if(viewModel.authProviders.contains(.email)) {
                emailSection
            }
            usernameSection
        }
        .onAppear() {
            viewModel.loadAuthProviders()
            print("Opened Settings")
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Settings")
    }

    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET!") // Put some sort of alert on the screen for the future
                    } catch {
                        print(error) // Change for future
                    }
                }
            }
            Button("Update Password") { // When doing this, user needs to verify current password or reauthenticate themsevles for firebase to let them reset it
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED!") // Put some sort of alert on the screen for the future
                    } catch {
                        print(error) // Change for future
                    }
                }
            }
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED!") // Put some sort of alert on the screen for the future
                    } catch {
                        print(error) // Change for future
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
    
    private var usernameSection: some View {
        Section {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Update Username") {
                Task {
                    do {
                        try await viewModel.updateUsername()
                        print("USERNAME UPDATED!") // Put some sort of alert on the screen for the future
                    } catch {
                        print(error) // Change for future
                    }
                }
            }
        } header: {
            Text("Username")
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}


