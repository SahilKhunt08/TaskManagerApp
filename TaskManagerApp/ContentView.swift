// To Do
//  Swipable Components
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                
                VStack {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .font(.system(size: 27))
                        .frame(width: 35, height: 35)
                    
                                 
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                
                
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
                
                VStack {
                    Image(systemName: "plus.square")
                        .resizable()
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .font(.system(size: 57))
                        .bold()
                    
                                 
                }.frame(maxWidth: 50, maxHeight: 50, alignment: .trailing)
                
                
            }
            
        }
        .padding()
        .navigationBarBackButtonHidden(true)

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
