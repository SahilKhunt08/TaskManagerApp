
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
    let db = Firestore.firestore()

    
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

}


struct ContentView: View {
    @State private var newListModalOpen = false
    @State private var newFamilyModalOpen = false
    @State private var addFamilyModalOpen = false
    @Binding var showSignInView: Bool
    @State private var firestoreIDs: [String] = ["00"] //get ids from firestore
    
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
                        ForEach(0..<firestoreIDs.count, id: \.self) { index in
                            ZStack {
                                Color.gray.opacity(0.2)
                                if firestoreIDs[index] == "00" { //show new/join family UI
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
                                            addFamilyModalOpen = true
                                        }, label: {
                                            Text("JF")
                                                .font(.title)
                                                .foregroundColor(.black)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }).sheet(isPresented: $addFamilyModalOpen, content: {
                                            AddFamilyView(addFamilyModalOpen: $addFamilyModalOpen)
                                        })
                                    }
                                } else { //get firestore data and store in cards
                                    ScrollView {
                                        Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                                            GridRow {
                                                ForEach(0..<2) {_ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text("\(index + 1)")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                                )
                                                    
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) {_ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text("\(index + 1)")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                                )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) {_ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text("\(index + 1)")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                                )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) {_ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text("\(index + 1)")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                                )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) {_ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text("\(index + 1)")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                                )
                                                }
                                            }
                                        }
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
            firestoreIDs = await viewModel.loadUserFamilies()
            firestoreIDs.append("00")
            print(firestoreIDs)
        }
        .toolbar(.hidden)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}


