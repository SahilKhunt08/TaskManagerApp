// To Do
//  Swipable Components
//



//test email details
//email: vtest1@gmail.com
//password: viddyp

import SwiftUI

struct ContentView: View {
    @State private var newListModalOpen  = false
    @State private var settingsButtonPressed: Bool = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        
//                        NavigationLink(destination: SettingsView(), isActive: $settingsButtonPressed) {
//                            EmptyView()
//                        }.toolbarRole(.editor)
//                        Button(action: {
//                            settingsButtonPressed = true
//                        }, label: {
//                            Image(systemName: "gearshape.fill")
//                                .resizable()
//                                .imageScale(.large)
//                                .foregroundStyle(.tint)
//                                .font(.system(size: 27))
//                                .frame(width: 35, height: 35)
//                        })
//                        
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
                        
                        
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    
                    VStack {
                        Text("List Name")
                            .bold()
                            .font(.largeTitle)
                            .frame(alignment: .leading)
                    }
                    
                    VStack {
                        
                        HStack { //Temp...will change
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundStyle(.tint)
                                .frame(width: 35, height: 35)
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundStyle(.tint)
                                .frame(width: 35, height: 35)
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundStyle(.tint)
                                .frame(width: 35, height: 35)
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundStyle(.tint)
                                .frame(width: 35, height: 35)
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundStyle(.tint)
                                .frame(width: 35, height: 35)
                        }
                    }
                    
                    Spacer()
                    
                }
                
            }
            .padding()
           
        }.toolbar(.hidden)
    }
}

#Preview {
    ContentView()
}
