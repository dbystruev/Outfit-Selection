//
//  NetworkManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

class NetworkManager {
    // MARK: - Class Properties
    static let defaultURL = URL(string: "http://server.getoutfit.ru")!
    static let shared = NetworkManager()
    
    // MARK: - Properties
    let url: URL
    
    // MARK: - Init
    private init(_ url: URL? = nil) {
        self.url = url ?? NetworkManager.defaultURL
    }
    
    // MARK: - Methods
    func getCategories(completion: @escaping (_ categories: [Category]?) -> Void) {
        let requestURL = url.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            guard let data = data else {
                let message = error?.localizedDescription ?? "Didn't get any data"
                print("\(#line) \(Self.self).\(#function) ERROR requesting \(requestURL): \(message)")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            guard let categories = try? decoder.decode([Category].self, from: data) else {
                let message = String(data: data, encoding: .utf8) ?? "nil"
                print("\(#line) \(Self.self).\(#function) ERROR decoding \(data): \(message)")
                completion(nil)
                return
            }
            
            completion(categories)
        }
        task.resume()
    }
}

