//
//  ContentView.swift
//  HotProspects
//
//  Created by Brandon Knox on 6/4/21.
//

import SwiftUI

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

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
    
    func fetchData(from urlString: String, completion: @escaping(Result<String, NetworkError>) -> Void) {
        DispatchQueue.main.async {
            completion(.failure(.badURL))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
