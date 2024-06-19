
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

@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published private(set) var user: AuthDataResultModel? = nil

    func loadCurrentUser() throws {
        self.user = try AuthenticationManager.shared.getAuthenticatedUser()
    }
    
}

struct ContentView: View {
    @State private var newListModalOpen = false
    @Binding var showSignInView: Bool
    private let firestoreIDs: [String] = ["id1", "id2", "id3", "id4", "00"] //get ids from firestore

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
                
                Spacer()
                Spacer()

                
                VStack {
                    TabView {
                        ForEach(firestoreIDs, id: \.self) { id in
                            ZStack {
                                Color.gray.opacity(0.2) // Background color for each page
                                if(id == "00") { //show new/join family UI
                                    Text(id)
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
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
        .onAppear() {
            try? viewModel.loadCurrentUser()
        }
        .toolbar(.hidden)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}
