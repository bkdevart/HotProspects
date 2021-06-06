//
//  ContentView.swift
//  HotProspects
//
//  Created by Brandon Knox on 6/4/21.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        Text("Hello world")
            .padding()
            .background(backgroundColor)
        
        Text("Change Color")
            .padding()
            .contextMenu {
                Button(action: {
                    self.backgroundColor = .red
                }) {
                    Text("Red")
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    self.backgroundColor = .green
                }) {
                    Text("Green")
                }
                
                Button(action: {
                    self.backgroundColor = .blue
                }) {
                    Text("Blue")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
