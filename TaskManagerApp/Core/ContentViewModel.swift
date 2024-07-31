//
//  ContentViewModel.swift
//  TaskManagerApp
//
//  Created by Vedant on 7/31/24.
//


import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore


@MainActor
final class ContentViewModel: ObservableObject {
    @Published var newListModalOpen = false
    @Published var newFamilyModalOpen = false
    @Published var addFamilyModalOpen = false
    @Published var firestoreIDs: [String] = ["00"]
    
    @Published private(set) var user: DBUser? = nil
    let db = Firestore.firestore()
    
    func getNewListModalOpen() -> Bool {
        return newListModalOpen
    }
    
    func setNewListModalOpen(_ value: Bool) {
        newListModalOpen = value
    }
    
    // Getter and Setter for newFamilyModalOpen
    func getNewFamilyModalOpen() -> Bool {
        return newFamilyModalOpen
    }
    
    func setNewFamilyModalOpen(_ value: Bool) {
        newFamilyModalOpen = value
    }
    
    // Getter and Setter for addFamilyModalOpen
    func getAddFamilyModalOpen() -> Bool {
        return addFamilyModalOpen
    }
    
    func setAddFamilyModalOpen(_ value: Bool) {
        addFamilyModalOpen = value
    }
    
    // Getter and Setter for firestoreIDs
    func getFirestoreIDs() -> [String] {
        return firestoreIDs
    }
    
    func setFirestoreIDs(_ value: [String]) {
        firestoreIDs = value
    }
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremmiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updatePremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
    func loadUserFamilies() async -> [String] {
        guard let user = user else {
            print("User is not set")
            return []
        }
        
        let docRef = db.collection("users").document(user.userId)
        
        do {
            let document = try await docRef.getDocument()
            let families = document.get("families") as? [String] ?? []
            return families
        } catch {
            print("Document does not exist or there was an error: \(error.localizedDescription)")
            return []
        }
    }
    
    func continuouslyRun() {
        Task {
            while true {
                // Your continuous code here
                firestoreIDs = await loadUserFamilies()
                firestoreIDs.append("00")
                print("ran")
                // Sleep for a short duration to prevent high CPU usage
                try await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
}
    
