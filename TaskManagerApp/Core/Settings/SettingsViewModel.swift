//
//  SettingsViewModel.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 6/10/24.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOption] = []
    @Published var username: String = ""

    
    func loadAuthProviders() {
        if let provider = try? AuthenticationManager.shared.getProviders() {
            authProviders = provider
        }
//        loadCurrentUsername()

    }
    
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
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123" //Temp password. Make sure to retrieve the current password being used
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func updateUsername() async throws {
        // Logic to update the username
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        try await UserManager.shared.updateUsername(userId: authDataResult.uid, username: username)
    }
    
//    func loadCurrentUsername() async {
//        do {
//            let userId = AuthenticationManager.shared.getAuthenticatedUser().uid
//            self.username = try await UserManager.shared.getCurrentUsername(userId: userId)
//        } catch {
//            print("Failed to load username: \(error)")
//        }
//    }
    
//delete
//    func togglePremmiumStatus() {
//        guard let user else { return }
//        let currentValue = user.isPremium ?? false
//        Task {
//            try await UserManager.shared.updatePremiumStatus(userId: user.userId, isPremium: !currentValue)
//            self.user = try await UserManager.shared.getUser(userId: user.userId)
//        }
//    }
}
