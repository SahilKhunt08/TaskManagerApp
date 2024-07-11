//
//  AddFamilyView.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 7/8/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct AddFamilyView: View {
    @State var familyCode = ""
    @State var listContent = ""
    @Binding var addFamilyModalOpen: Bool
    let db = Firestore.firestore()
    
    @StateObject private var viewModel = FamilyViewModel()
    
    var body: some View {
        VStack {
            Form {
                Text("1️⃣ Enter Family Code ")
                    .font(.system(size: 20))
                    .bold()
                TextField("Family Code", text: $familyCode)
                
                if let user = viewModel.user {
                    Text("UserId: \(user.userId)")
                    Button(action: {
                        viewModel.checkFamilyCode(familyCode: familyCode) { (exists, family_id) in
                            if exists, let family_id = family_id {
                                print("Family code exists with family_id: \(family_id)")
                                // Add user to family
                                viewModel.addUserToFamily(family_id: family_id)
                            } else {
                                print("Family code not found")
                                // Handle the case where the family code is not found
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
                    
                } else {
                    Text("does not work")
                }
            }
        }
        .task() {
            try? await viewModel.loadCurrentUser()
            print("Opened AddFamilyView")
        }
    }
}



struct AddFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        AddFamilyView(addFamilyModalOpen: .constant(false))
    }
}

