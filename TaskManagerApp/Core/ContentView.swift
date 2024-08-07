
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
    @Published var newListModalOpen = false
    @Published var newFamilyModalOpen = false
    @Published var addFamilyModalOpen = false
    @Published var firestoreIDs: [String] = ["00"]
    @Published var currFamilyName = ""
    
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
    
    func setCurrFamilyName(_ value: String) {
        currFamilyName = value
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
    
    func getListGrid(familyName: String) {
        setCurrFamilyName(familyName)
        print(familyName)
        let listsRef = db.collection("families").document(familyName).collection("lists")
        listsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        //get all lists in that family
        //get dimensions of the grid
    }
}





struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @Binding var showSignInView: Bool
    
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
                        viewModel.setNewListModalOpen(true)
                    }, label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .imageScale(.medium)
                            .foregroundStyle(.tint)
                            .font(.system(size: 20))
                            .frame(width: 30, height: 30)
                            .bold()
                    }).sheet(isPresented: $viewModel.newListModalOpen, content: {
                        NewListView(newListModalOpen: $viewModel.newListModalOpen)
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                Text("\(viewModel.currFamilyName)")
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
                        ForEach(viewModel.firestoreIDs, id: \.self) { id in
                            ZStack {
                                Color.gray.opacity(0.2)
                                if id == "00" { // show new/join family UI
                                    HStack {
                                        Button(action: {
                                            viewModel.newFamilyModalOpen = true
                                        }, label: {
                                            Text("NF")
                                                .font(.title)
                                                .foregroundColor(.black)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }).sheet(isPresented: $viewModel.newFamilyModalOpen) {
                                            NewFamilyView(newFamilyModalOpen: $viewModel.newFamilyModalOpen)
                                        }
                                        Button(action: {
                                            viewModel.addFamilyModalOpen = true
                                        }, label: {
                                            Text("JF")
                                                .font(.title)
                                                .foregroundColor(.black)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }).sheet(isPresented: $viewModel.addFamilyModalOpen) {
                                            AddFamilyView(addFamilyModalOpen: $viewModel.addFamilyModalOpen)
                                        }
                                    }
                                } else {
                                    ScrollView {
                                        Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                                            GridRow {
                                                ForEach(0..<2) { _ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text(id)
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) { _ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text(id)
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) { _ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text(id)
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) { _ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text(id)
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                            }
                                            GridRow {
                                                ForEach(0..<2) { _ in
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(height: 170)
                                                        .overlay(
                                                            Text(id)
                                                                .font(.largeTitle)
                                                                .foregroundColor(.white)
                                                        )
                                                }
                                            }
                                        }
                                        
                                    //Vedant
                                    }.onAppear() {
                                        //call viewModel Function
                                        
                                        viewModel.getListGrid(familyName: id)
                                        
                                        
                                    }
                                    //
                                    
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
        }.task {
            try? await viewModel.loadCurrentUser()
            viewModel.continuouslyRun()
            print(viewModel.getFirestoreIDs())
        }.toolbar(.hidden)
    }
}
                                   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}


