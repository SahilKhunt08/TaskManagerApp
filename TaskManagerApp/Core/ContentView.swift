
//
//  RootView.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 6/2/24.
//
//  test email details
//  email: vtest1@gmail.com
//  password: viddyp
//

import SwiftUI

import FirebaseCore
import FirebaseFirestore

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
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
}

struct ContentView: View {
    @State private var newListModalOpen = false
    @State private var newFamilyModalOpen = false
    @Binding var showSignInView: Bool
    public var firestoreIDs: [String] = ["00"] //get ids from firestore
    let db = Firestore.firestore()

    
    @StateObject private var viewModel = ContentViewModel()
    
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    NavigationLink(destination: SettingsView(showSignInView: $showSignInView)) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            .font(.system(size: 27))
                            .frame(width: 35, height: 35)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        newListModalOpen = true
                    }, label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .imageScale(.medium)
                            .foregroundStyle(.tint)
                            .font(.system(size: 20))
                            .frame(width: 30, height: 30)
                            .bold()
                    }).sheet(isPresented: $newListModalOpen, content: {
                        NewListView(newListModalOpen: $newListModalOpen)
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text("List Name")
                    .bold()
                    .font(.largeTitle)
                    .frame(alignment: .leading)
                
                HStack { // Temp...will change
                    ForEach(0..<5) { _ in
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .foregroundStyle(.tint)
                            .frame(width: 35, height: 35)
                    }
                }
                if let user = viewModel.user {
                    Text("UserId: \(user.userId)")
                    Button {
                        viewModel.togglePremmiumStatus()
                    } label: {
                        Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                    }
                }
                Spacer()
                Spacer()
                
                
                VStack {
                    TabView {
                        ForEach(firestoreIDs, id: \.self) { id in
                            ZStack {
                                Color.gray.opacity(0.2)
                                if(id == "00") { //show new/join family UI
                                    HStack {
                                        Button(action: {
                                            newFamilyModalOpen = true
                                        }, label: {
                                            Text("NF")
                                                .font(.title)
                                                .foregroundColor(  .black)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }).sheet(isPresented: $newFamilyModalOpen, content: {
                                            NewFamilyView(newFamilyModalOpen: $newFamilyModalOpen)
                                        })
                                        
                                        Button(action: {
                                        }, label: {
                                            Text("JF")
                                                .font(.title)
                                                .foregroundColor(.black)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        })
                                    }
                                } else { //get firestore data and store in cards
                                    Text(id)
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .onAppear{
                                            
                                        }
                                }
                            }
                            
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    .cornerRadius(30)
                }
            }
            .padding()
        }
        .task() {
            try? await viewModel.loadCurrentUser()
            print("Opened ContentView")
            if let user = viewModel.user {
                print("auth works")
                let docRef = db.collection("users").document("\(user.userId)")
                docRef.getDocument { (document, error) in
                           if let document = document, document.exists {
                               // Access the array field
                               if let arrayField = document.get("families") as? [String] {
                                   print("Array field: \(arrayField)")
                                   firestoreIDs = arrayField
                               } else {
                                   print("Array field is not found or not an array")
                               }
                           } else {
                               print("Document does not exist or error: \(String(describing: error))")
                           }
                       }

            }
            

        }
        .toolbar(.hidden)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}

