//
//  RootView.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 6/2/24.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
//                ContentView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            print(showSignInView)
        }
        
        
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
