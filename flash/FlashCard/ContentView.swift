//
//  ContentView.swift
//  flash
//
//  Created by Songwut Maneefun on 24/9/2564 BE.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @ObservedObject var observed = Observer()
    
    var body: some View {
        NavigationView{
            List(observed.jokes){ i in
                HStack{Text(i.joke)}
                }.navigationBarItems(
                  trailing: Button(action: addJoke, label: { Text("Add") }))
            .navigationBarTitle("SwiftUI Alamofire")
        }
    }
    
    func addJoke(){
        observed.getJokes(count: 1)
    }
}

struct JokesData : Identifiable{
    
    public var id: Int
    public var joke: String
}

class Observer : ObservableObject{
    @Published var jokes = [JokesData]()

    init() {
        getJokes()
    }
    
    func getJokes(count: Int = 5) {
        //Alamofire
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
