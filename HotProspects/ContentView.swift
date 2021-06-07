//
//  ContentView.swift
//  HotProspects
//
//  Created by Brandon Knox on 6/4/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            ProspectsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Everyone")
                }
            
            ProspectsView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Contacted")
                }
            
            ProspectsView()
                .tabItem {
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
                }
            
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Me")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
