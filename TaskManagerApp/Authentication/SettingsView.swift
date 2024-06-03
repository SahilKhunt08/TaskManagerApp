//
//  SettingsView.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 6/2/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws { //Code some logic so that you can reset password when email was not previously entered
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist) //Change to a custom error for the future
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "hello123@gmail.com" //Temp email. Make sure to retrieve the current email being used
        try await AuthenticationManager.shared.updateEmil(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123" //Temp password. Make sure to retrieve the current password being used
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}

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
                    } catch {
                        print(error) // Change for future
                    }
                }
            }

            emailSection
            
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    
    private var emailSection: some View {
        Section {
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("PASSWORD RESET!") //Put some sort of alert on the screen for the future
                    } catch {
                        print(error) // Change for future
                    }
                }
            }
            Button("Update Password") { // When doing this, user needs to verify current password or reauthenticate themsevles for firebase to let them reset it
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("PASSWORD UPDATED!") //Put some sort of alert on the screen for the future
                    } catch {
                        print(error) // Change for future
                    }
                }
            }
            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("EMAIL UPDATED!") //Put some sort of alert on the screen for the future
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


