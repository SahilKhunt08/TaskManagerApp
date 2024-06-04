//
//  TaskManagerAppApp.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 5/30/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

@main
struct TaskManagerAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
//            RootView()
            ContentView()
//            LoginView()
            
//            NavigationStack {
//                AuthenticationView()
//            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    return true
  }
}

