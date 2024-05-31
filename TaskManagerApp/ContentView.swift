//
//  ContentView.swift
//  TaskManagerApp
//
//  Created by Sahil Khunt on 5/30/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to the Home Page!")
                .font(.largeTitle)
                .padding()
        }
        .padding()
        .navigationBarBackButtonHidden(true)  // Hide the back button

    }
}

#Preview {
    ContentView()
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
