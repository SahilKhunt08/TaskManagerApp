//
//  NewFamilyViewModel.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 7/8/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@MainActor
final class NewFamilyViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func addUserToFamily(text: String) {
        guard let user else { return }
        
        Task {
            try await UserManager.shared.addFamily(userId: user.userId, family: text)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func generateRandomPassword() -> String {
        let digits = "0123456789"
        return String((0..<5).map { _ in digits.randomElement()! })
    }
    
    func checkPasswordUniqueness(password: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("passwords").document(password).getDocument { (document, error) in
            if let document = document, document.exists {
                completion(false) // Password already exists
            } else {
                completion(true) // Password is unique
            }
        }
    }
    
    func generateUniquePassword(completion: @escaping (String) -> Void) {
        func generateAndCheckPassword() {
            let password = generateRandomPassword()
            checkPasswordUniqueness(password: password) { isUnique in
                if isUnique {
                    completion(password)
                } else {
                    generateAndCheckPassword() // Generate a new password and check again
                }
            }
        }
        generateAndCheckPassword()
    }
    
    func addPasswordToFirestore(password: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("passwords").document(password).setData(["code": password]) { error in
            completion(error)
        }
    }
    
}
