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
            
            if(viewModel.authProviders.contains(.email)) {
                emailSection
            }
        }
        .onAppear() {
            viewModel.loadAuthProviders()
            print("Opened Settings")
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
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}


