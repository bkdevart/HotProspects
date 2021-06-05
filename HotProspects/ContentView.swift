//
//  ContentView.swift
//  HotProspects
//
//  Created by Brandon Knox on 6/4/21.
//

import SwiftUI

class DelayedUpdater: ObservableObject {
    @Published var value = 0
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var updater = DelayedUpdater()
    
    var body: some View {
        Text("Value is: \(updater.value)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
