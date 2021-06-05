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
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let stringData = String(decoding: data, as: UTF8.self)
                    completion(.success(stringData))
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
