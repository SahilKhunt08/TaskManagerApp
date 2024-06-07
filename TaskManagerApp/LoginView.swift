////
////  LoginView.swift
////  TaskManagerApp
////
////  Created by Sahil Khunt on 5/30/24.
////
//
//import Foundation
//import SwiftUI
//
//struct LoginView: View {
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var isLoggedIn: Bool = false
//    @State private var selection: Int = 0
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Log in")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.bottom, 40)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//
//                Text("Email Address")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//                TextField("Enter email here", text: $email)
//                    .autocapitalization(.none)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                    .padding(.bottom, 20)
//                    .cornerRadius(/*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
//
//                Text("Password")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal)
//                SecureField("Enter password here", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.horizontal)
//                    .padding(.bottom, 20)
//
//                HStack {
//                    Spacer()
//                    Button("Forgot password?") {
//                        // Action for forgot password
//                    }
////                    .font(.footnote)
//                    .padding(.horizontal)
//                    .foregroundColor(.black)
//                }
//
//                //NavigationLink(destination: ContentView(), isActive: $isLoggedIn) {
//                    EmptyView()
//                }
//
//                Button(action: {
//                    // Replace with your actual login logic
//                    if email == "email" && password == "password" {
//                        isLoggedIn = true
//                    }
//                }) {
//                    Text("Log in")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.black)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal)
//                .padding(.top, 20)
//
//                Text("Or Login with")
//                    .padding(.top, 20)
//                    .padding(.bottom, 10)
//
//                HStack(spacing: 20) {
//                    Button(action: {
//                        // Action for Apple login
//                    }) {
//                        Image("AppleIcon")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                            .aspectRatio(contentMode: .fit)
//                    }
//
//                    Button(action: {
//                        // Action for Google login
//                    }) {
//                        Image("GoogleIcon")
//                            .resizable()
//                            .frame(width: 50, height: 50)
//                    }
//                }
//                .padding(.top, 20)
//
////                Spacer()
//
//                HStack {
//                    Text("Don’t have an account?")
//                    Button("Sign up") {
//                        selection = 1
//                    }
//                }
//                .padding(.bottom, 20)
//            }
//            .navigationTitle("")
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
