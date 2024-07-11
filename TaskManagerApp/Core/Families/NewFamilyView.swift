//
//  NewFamilyView.swift
//  TaskManagerApp
//
//  Created by Vedant on 6/20/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct NewFamilyView: View {
    @State var familyName = ""
    @State var listContent = ""
    @State var deleteOption = ""
    @Binding var newFamilyModalOpen: Bool
    let db = Firestore.firestore()
    
    @StateObject private var viewModel = FamilyViewModel()
    
    var body: some View {
        VStack {
            Form {
                Text("1️⃣ Set a Family Name ")
                    .font(.system(size: 20))
                    .bold()
                TextField("Family Name", text: $familyName)
                
                if let user = viewModel.user {
                    Text("UserId: \(user.userId)")
                    Button(action: {
                        viewModel.generateUniquePassword { password in
                            let ref = db.collection("families").document()
                            ref.setData([
                                "id": ref.documentID,
                                "name": familyName,
                                "members": [user.userId],
                                "code": password
                            ]) { error in
                                if let error = error {
                                    print("Error adding document: \(error)")
                                } else {
                                    print("Document successfully added with ID: \(ref.documentID)")
                                    
                                    // Add the family ID to the user's families array
                                    Task {
                                        do {
                                            try await UserManager.shared.addFamily(userId: user.userId, family: ref.documentID)
                                            print("Family ID added to user's families array")
                                        } catch {
                                            print("Error adding family ID to user's families array: \(error)")
                                        }
                                    }
                                    
                                    // Add the document ID to the passwords collection
                                    viewModel.addPasswordToFirestore(password: password, familyDocumentId: ref.documentID) { error in
                                        if let error = error {
                                            print("Error adding password to Firestore: \(error)")
                                        } else {
                                            print("Password added to Firestore: \(password)")
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Submit")
                            .font(.system(size: 20))
                            .padding(.horizontal, 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Color 1"))
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        TextField("Enter 1, 2, or 3", text: $deleteOption)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        
                        Button(action: {
                            guard !deleteOption.isEmpty else {
                                print("No option entered")
                                return
                            }
                            
                            switch deleteOption {
                            case "1":
                                viewModel.deleteAllDocuments(in: "families") { error in
                                    if let error = error {
                                        print("Error deleting families: \(error)")
                                    } else {
                                        print("All families deleted successfully")
                                    }
                                }
                            case "2":
                                viewModel.deleteAllDocuments(in: "passwords") { error in
                                    if let error = error {
                                        print("Error deleting passwords: \(error)")
                                    } else {
                                        print("All passwords deleted successfully")
                                    }
                                }
                            case "3":
                                viewModel.deleteAllDocuments(in: "users") { error in
                                    if let error = error {
                                        print("Error deleting users: \(error)")
                                    } else {
                                        print("All users deleted successfully")
                                    }
                                }
                            default:
                                print("Invalid option")
                            }
                        }) {
                            Text("Delete")
                                .font(.system(size: 20))
                                .padding(.horizontal, 50)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .frame(maxWidth: .infinity)
                    }
                    
                } else {
                    Text("does not work")
                }
            }
        }
        
        .task() {
            try? await viewModel.loadCurrentUser()
            print("Opened NewFamilyView")
        }
    }
}

struct NewFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NewFamilyView(newFamilyModalOpen: .constant(false))
    }
}

