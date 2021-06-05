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
            Text("Tab 1")
                .tabItem {
                    Image(systemName: "star")
                    Text("One")
                }
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Two")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
