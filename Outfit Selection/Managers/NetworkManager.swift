//
//  NetworkManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class NetworkManager {
    // MARK: - Static Properties
    static let defaultURL = URL(string: "http://server.getoutfit.ru")!
    static let shared = NetworkManager()
    
    // MARK: - Stored Properties
    /// Maximum number of simultaneous get requests (image loading is not counted)
    let maxRequests = 2
    
    /// Number of get requests currently running (image loading is not counted)
    var numberOfRequestsRunning = 0
    
    // API server URL
    let url: URL
    
    // MARK: - Init
    private init(_ url: URL? = nil) {
        self.url = url ?? NetworkManager.defaultURL
    }
    
    // MARK: - Methods
    /// Send get request with parameters and call completion when done
    /// - Parameters:
    ///   - path: path to add to server URL
    ///   - parameters: query parameters to add to request
    ///   - completion: closure called after request is finished, with data if successfull, or with nil if not
    func get<T: Codable>(_ path: String, parameters: [String: Any] = [:], completion: @escaping (T?) -> Void) {
        
        let request = url.appendingPathComponent(path).withQueries(parameters)
        
        debug("request = \(request)")
        
        // Check that we don't run more than allowed number of get requests in parallel
        guard numberOfRequestsRunning < maxRequests else {
            debug("ERROR: the number of requests \(numberOfRequestsRunning) is not lower than maximum \(maxRequests)")
            completion(nil)
            return
        }
        
        numberOfRequestsRunning += 1
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            self.numberOfRequestsRunning -= 1
            
            guard let data = data else {
                let message = error?.localizedDescription ?? "No data"
                debug("ERROR requesting \(request): \(message)")
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
    
    /// Add /categories?limit=999999 to server URL and call the API
    /// - Parameter completion: closure called after the request is finished, with list of categories if successfull, or with nil if not
    func getCategories(completion: @escaping (_ categories: [Category]?) -> Void) {
        get("categories", parameters: ["limit": 999999], completion: completion)
    }
    
    /// Download image from the given URL
    /// - Parameters:
    ///   - url: url to download image from
    ///   - completion: closure called after request is finished, with image if successfull, with nil if not
    func getImage(_ url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                let message = error?.localizedDescription ?? "No data"
                debug("ERROR requesting \(url): \(message)")
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                debug("ERROR converting \(data) at \(url) to image")
                completion(nil)
                return
            }
            
            completion(image)
        }
        
        task.resume()
    }
    
    /// Add /offers?categoryId=...&categoryId=...&vendor=...&vendor=...&limit=... to server URL and call the API
    /// - Parameters:
    ///   - categories: the list of categories to filter items by
    ///   - gender: load female or male items only, both if nil
    ///   - vendors: the list of vendors to filter items by
    ///   - completion: closure called when request is finished, with the list of items if successfull, or with nil if not
    func getOffers(inCategories categories: [Category] = [],
                   filteredBy gender: Gender? = nil,
                   forVendors vendors: [String] = [],
                   completion: @escaping ([Item]?) -> Void) {
        
        // Prepare parameters
        var parameters: [String: Any] = ["limit": Item.maxCount]
        parameters["categoryId"] = categories.isEmpty ? nil : categories.map { $0.id }
        parameters["vendor"] = vendors.isEmpty ? nil : vendors
        
        // Add gender in parameter
        switch gender {
        case .female:
            parameters["пол"] = "женский"
        case .male:
            parameters["пол"] = "мужской"
        default:
            break
        }
        
        // Send the get request
        get("offers", parameters: parameters, completion: completion)
    }
    
    /// Add /offers?categoryId=...&limit=... to server URL and call the API
    /// - Parameters:
    ///   - category: category id to get the items from
    ///   - completion: closure called when request is finished, with the list of items if successfull, or with nil if not
    func getOffers(inCategory category: Category, completion: @escaping ([Item]?) -> Void) {
        get("offers",
            parameters: ["categoryId": category.id, "limit": Category.maxItemCount],
            completion: completion)
    }
}

