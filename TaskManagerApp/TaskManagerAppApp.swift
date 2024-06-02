//
//  TaskManagerAppApp.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 5/30/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

// Firebase code
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      Auth.auth().useEmulator(withHost: "localhost" , port: 9099)
    return true
  }
}


@main
struct TaskManagerAppApp: App {
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
//            NavigationView {
                LoginView()
//            }
        }
    }
}
