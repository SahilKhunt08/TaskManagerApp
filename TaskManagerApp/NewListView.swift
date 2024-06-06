//
//  NewListView.swift
//  TaskManagerApp
//
//  Created by Vedant on 6/2/24.
//

import Foundation
import SwiftUI

import FirebaseCore
import FirebaseFirestore

struct NewListView: View {
    @State var listName = ""
    @State var listContent = ""
    @Binding var newListModalOpen: Bool
    let db = Firestore.firestore()
    
    
    let userData: [String: Any] = [
               "firstName": "John",
               "lastName": "Doe",
               "age": 30,
               "email": "john.doe@example.com"
           ]
    var body: some View {
        
        
        VStack{
            Spacer()

            Text("📋 List Creator")
                .font(.system(size: 35))
                .bold()

            Form {
                
                Text("1️⃣ Set a Name ")
                    .font(.system(size: 20))
                    .bold()
                TextField("List Name", text: $listName)
                Text("2️⃣ Format the List ")
                    .font(.system(size: 20))
                    .bold()
                TextField("Title", text: $listContent,  axis: .vertical)
                    .lineLimit(20...50)
                
                Button(action: {
                    newListModalOpen = false
                    db.collection("lists").addDocument(data: userData)
                        
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


struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewListView(newListModalOpen: .constant(false))
    }
}
