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
                        
                        viewModel.generateUniquePassword { password in
                                                    viewModel.addPasswordToFirestore(password: password) { error in
                                                        if let error = error {
                                                            print("Error adding password to Firestore: \(error)")
                                                        } else {
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
                                                                    viewModel.addUserToFamily(text: familyName)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                        
//                        var uniquePassword = ""
//                        let ref = db.collection("families").document()
//                        viewModel.generateUniquePassword { password in
//                            uniquePassword = password
//                            viewModel.addPasswordToFirestore(password: password) { error in
//                                if let error = error {
//                                    print("Error adding password to Firestore: \(error)")
//                                } else {
//                                    print("Password added to Firestore: \(password)")
//                                }
//                            }
//                            print(uniquePassword)
//                        }
//                        ref.setData([
//                            "id": ref.documentID,
//                            "name": familyName,
//                            "members": [user.userId],
//                            "code": uniquePassword
//                        ]) { error in
//                            if let error = error {
//                                print("Error adding document: \(error)")
//                            } else {
//                                print("Document successfully added with ID: \(ref.documentID)")
//                                viewModel.addUserToFamily(text: familyName)
//                            }
//                        }
                        
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

