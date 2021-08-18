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
    //    static let defaultURL = URL(string: "http://sc.getoutfit.ru")!
//    static let defaultURL = URL(string: "http://37.18.100.119")!
    static let shared = NetworkManager()
    
    // MARK: - Stored Properties
    /// Maximum number of simultaneous get requests (image loading is not counted)
    let maxRequestsInParallel = 5
    
    /// Number of get requests currently running (image loading is not counted)
    var numberOfRequestsRunning = 0
    
    // API server URL
    var url: URL
    
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
        
        // Check that we don't run more than allowed number of get requests in parallel
        guard numberOfRequestsRunning < maxRequestsInParallel else {
            debug("ERROR: the number of requests \(numberOfRequestsRunning) is not lower than maximum \(maxRequestsInParallel)")
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
            
            let message = String(data: data, encoding: .utf8) ?? "Unknown data format"
            Logger.log("GET", request.absoluteString);
            Logger.log("RESPONSE", message)
            
            guard let decodedData = try? JSON.decoder.decode(T.self, from: data) else {
                debug("ERROR decoding \(data): \(message)")
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
    ///   - categories: the list of categories to filter items by, should not be empty
    ///   - gender: load female or male items only, both if nil
    ///   - vendors: the list of vendors to filter items by
    ///   - singleRequest: true — run one single request, false — separate request for each category in parallel, nil — decide based on gender
    ///   - completion: closure called when request is finished, with the list of items if successfull, or with nil if not
    func getOffers(inCategories categories: [Category],
                   filteredBy gender: Gender? = nil,
                   forVendors vendors: [String] = [],
                   withSingleRequest singleRequest: Bool? = true,
                   completion: @escaping ([Item]?) -> Void) {
        // Run single request if said so, or if not defined and gender is male
        let singleRequest = singleRequest ?? false
        
        if singleRequest {
            // Prepare parameters
            let parameters = getParameters(inCategories: categories, filteredBy: gender, forVendors: vendors)
            
            // Run signle request
            get("offers", parameters: parameters, completion: completion)
        } else {
            // The array of items we will collect the result in
            var allItems = [Item]()
            
            // Make several category requests in parallel
            let group = DispatchGroup()
            
            // Create a separate request for each category and each vendor
            for category in categories {
                // Prepare parameters
                let parameters = getParameters(inCategories: [category], filteredBy: gender, forVendors: vendors)
                
                // Enter the dispatch group before the request
                group.enter()
                
                // Request the items in the current category
                get("offers", parameters: parameters) { (items: [Item]?) in
                    // Add items to all items if we got any
                    if let items = items {
                        allItems.append(contentsOf: items)
                    }
                    
                    // Leave the dispatch group when request is completed
                    group.leave()
                }
            }
            
            // When all requests are finished make sure items are not nil
            group.notify(queue: .main) {
                guard !allItems.isEmpty else {
                    completion(nil)
                    return
                }
                completion(allItems)
            }
        }
    }
    
    /// Prepare parameters dictionary for given categories, gender, and vendors
    /// - Parameters:
    ///   - categories: the list of categories to filter items by
    ///   - gender: load female or male items only, both if nil or other
    ///   - vendors: the list of vendors to filter items by
    /// - Returns: dictionary with parameters suitable to call get()
    func getParameters(inCategories categories: [Category] = [],
                    filteredBy gender: Gender? = nil,
                    forVendors vendors: [String] = []) -> [String: Any] {
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
        case .other, nil:
            break
        }
        
        return parameters
    }
    
    /// Update the main url we have to use in the future
    /// - Parameter completion: closure called when request is finished, with true if request is succesfull, and false if not
    func updateURL(completion: @escaping (_ success: Bool) -> Void) {
        get("server") { (decodedData: [String: URL]?) in
            guard let url = decodedData?["server"] else {
                debug("ERROR: Can't find server in decoded data", decodedData)
                completion(false)
                return
            }
            
            self.url = url
            debug("Updated server url to \(url)")
            completion(true)
        }
    }
}
