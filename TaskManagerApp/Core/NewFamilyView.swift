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
   
    var body: some View {
        VStack {
            Form {
                Text("1️⃣ Set a Family Name ")
                    .font(.system(size: 20))
                    .bold()
                TextField("Family Name", text: $familyName)
                
                Button(action: {
                    let ref = db.collection("families").document()
                    ref.setData([
                        "id": ref.documentID,
                        "name": familyName,
                    ]) { error in
                        if let error = error {
                               print("Error adding document: \(error)")
                           } else {
                               print("Document successfully added with ID: \(ref.documentID)")
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
                
            }
        }
    }
}


struct NewFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NewFamilyView(newFamilyModalOpen: .constant(false))
    }
}

