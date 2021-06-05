//
//  ContentView.swift
//  HotProspects
//
//  Created by Brandon Knox on 6/4/21.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        Text("hello, world!")
            .onAppear {
                let url = URL(string: "https://www.appple.com")!
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if data != nil {
                        print("We got data!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
