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
    @State var listName = ""
    @State var listContent = ""
    @Binding var newFamilyModalOpen: Bool
    let db = Firestore.firestore()
   
    var body: some View {
        VStack {
            Text("hi")
        }
    }
}


struct NewFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NewFamilyView(newFamilyModalOpen: .constant(false))
    }
}

