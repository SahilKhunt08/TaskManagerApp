
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
                                } else { // get firestore data and store in cards
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
        
        .task {
            try? await viewModel.loadCurrentUser()
            viewModel.continuouslyRun()
            print(viewModel.getFirestoreIDs())
        }
        .toolbar(.hidden)
        
    }
}
                                   

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}


