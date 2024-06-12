//
//  SignInEmailViewModel.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 6/10/24.
//

import Foundation

@MainActor //Learn this line
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")   //Need validation here for the future
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)            }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")   //Need validation here for the future
            return
        }
        
        let _ = try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
