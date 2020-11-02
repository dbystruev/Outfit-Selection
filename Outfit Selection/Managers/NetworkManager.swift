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
    func get<T: Codable>(_ path: String, parameters: [String: Any] = [:], completion: @escaping (T?) -> Void) {
        let request = url.appendingPathComponent(path).withQueries(parameters)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                let message = error?.localizedDescription ?? "No data"
                print("\(#line) \(Self.self).\(#function) ERROR requesting \(request): \(message)")
                completion(nil)
                return
            }
            
            guard let decodedData = try? JSON.decoder.decode(T.self, from: data) else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown data format"
                print("\(#line) \(Self.self).\(#function) ERROR decoding \(data): \(message)")
                completion(nil)
                return
            }
            
            completion(decodedData)
        }
        
        task.resume()
    }
    
    func getCategories(completion: @escaping (_ categories: [Category]?) -> Void) {
        get("categories", parameters: ["limit": 999999], completion: completion)
    }
    
    func getOffers(in category: Category, completion: @escaping ([Offer]?) -> Void) {
        get("offers", parameters: ["categoryId": category.id], completion: completion)
    }
}

