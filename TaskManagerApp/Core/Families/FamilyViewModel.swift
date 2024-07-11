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
final class FamilyViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func addUserToFamily(family_id: String) {
        guard let user else { return }
        
        Task {
            do {
                let db = Firestore.firestore()
                
                // Add user ID to family's members array
                let familyRef = db.collection("families").document(family_id)
                try await familyRef.updateData([
                    "members": FieldValue.arrayUnion([user.userId])
                ])
                
                // Add family ID to user's families array
                let userRef = db.collection("members").document(user.userId)
                try await userRef.updateData([
                    "families": FieldValue.arrayUnion([family_id])
                ])
                
                print("User added to family and family added to user")
            } catch {
                print("Error adding user to family or family to user: \(error)")
            }
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
    
    func addPasswordToFirestore(password: String, familyDocumentId: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("passwords").document(password).setData([
            "code": password,
            "family_id": familyDocumentId
        ]) { error in
            completion(error)
        }
    }
    
    func checkFamilyCode(familyCode: String, completion: @escaping (Bool, String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("passwords").document(familyCode).getDocument { (document, error) in
            if let document = document, document.exists, let data = document.data(), let family_id = data["family_id"] as? String {
                completion(true, family_id) // Family code exists and retrieve the family_id
            } else {
                completion(false, nil) // Family code does not exist
            }
        }
    }
    
    func deleteAllDocuments(in collection: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(collection)
        
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(nil)
                return
            }
            
            let batch = db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { batchError in
                completion(batchError)
            }
        }
    }
}


