
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
    @Binding var showSignInView: Bool
    
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    // NavigationLink for SettingsView
//                    NavigationLink(destination: SettingsView(showSignInView: .constant(false))) {
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
            }
            .padding()
        }
        .task() {
            try? await viewModel.loadCurrentUser()
            print("Opened ContentView")
        }
        .toolbar(.hidden)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}
