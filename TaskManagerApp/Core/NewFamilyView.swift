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

@MainActor
final class NewFamilyViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}

struct NewFamilyView: View {
    @State var familyName = ""
    @State var listContent = ""
    @Binding var newFamilyModalOpen: Bool
    let db = Firestore.firestore()
    
    @StateObject private var viewModel = NewFamilyViewModel()
    
    
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
                        let familyRef = db.collection("families").document()
                        familyRef.setData([
                            "id": familyRef.documentID,
                            "name": familyName,
                            "members": [user.userId]
                            
                        ]) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                print("Document successfully added with ID: \(familyRef.documentID)")
                            }
                        }
                        
                        let userRef = db.collection("users").document("\(user.userId)")
                        userRef.updateData([
                            "families": [familyRef.documentID]
                            ])
                        
                    }) {
                        Text("Submit")
                            .font(.system(size: 20))
                            .padding(.horizontal, 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Color 1"))
                    .frame(maxWidth: .infinity)
                    
                } else {
                    Text("does not work")
                }
                
            }
        }
        .task() {
            try? await viewModel.loadCurrentUser()
            print("Opened ContentView")
        }
    }
}


struct NewFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NewFamilyView(newFamilyModalOpen: .constant(false))
    }
}

