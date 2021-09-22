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
    //    static let defaultURL = URL(string: "http://api.getoutfit.co")!
    //    static let defaultURL = URL(string: "http://server.getoutfit.ru")!
    static let defaultURL = URL(string: "http://spb.getoutfit.co:3000")!
    static let shared = NetworkManager()
    
    // MARK: - Stored Properties
    /// Maximum number of simultaneous get requests (image loading is not counted)
    let maxRequestsInParallel = 1024
    
    /// Number of get requests currently running (image loading is not counted)
    var numberOfRequestsRunning = 0
    
    // API server URL
    var url: URL
    
    // MARK: - Init
    private init(_ url: URL? = nil) {
        self.url = url ?? NetworkManager.defaultURL
    }
    
    /// Decode the data given with JSON
    /// - Parameter data: the data received from the server or from the cache
    /// - Returns: decoded data as Codable type if success, nil in case of fail
    func decode<T: Codable>(_ data: Data) -> T? {
        // Try to decode as value or as first element of an array
        let decodedValue = try? JSON.decoder.decode(T.self, from: data)
        let decodedArray = try? JSON.decoder.decode([T].self, from: data).first
        
        // If both failed show error message
        guard let decodedData = decodedValue ?? decodedArray else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown data format"
            debug("ERROR decoding \(data): \(message)")
            return nil
        }
        
        return decodedData
    }
    
    // MARK: - Methods
    /// Send get request with parameters and call completion when done
    /// - Parameters:
    ///   - path: path to add to server URL
    ///   - parameters: query parameters to add to request
    ///   - completion: closure called after request is finished, with data if successfull, or with nil if not
    func get<T: Codable>(_ path: String, parameters: [String: Any] = [:], completion: @escaping (T?) -> Void) {
        
        // Compose the request URL
        let requestPath = url.appendingPathComponent(path)
        let request = parameters.isEmpty ? requestPath : requestPath.withQueries(parameters)
        
        // Check if we already may have the needed request in the cache
        if
            let response = Logger.get(for: request.absoluteString),
            let data = response.data(using: .utf8),
            let decodedData: T = decode(data)
        {
            completion(decodedData)
            return
        }
        
        // Check that we don't run more than allowed number of get requests in parallel
        guard numberOfRequestsRunning <= maxRequestsInParallel else {
            debug("ERROR: the number of network get requests should not exceed \(maxRequestsInParallel)")
            completion(nil)
            return
        }
        
        numberOfRequestsRunning += 1
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            self.numberOfRequestsRunning -= 1
            
            debug(request.absoluteString)
            
            // Check if we haven't received nil
            guard let data = data else {
                let message = error?.localizedDescription ?? "No data"
                debug("ERROR requesting \(request): \(message)")
                completion(nil)
                return
            }
            
            // Decode the received data
            guard let decodedData: T = self.decode(data) else {
                completion(nil)
                return
            }
            
            // Store the message in logger cache
            let message = String(data: data, encoding: .utf8)
            Logger.log(key: request.absoluteString, message)
            completion(decodedData)
        }
        
        task.resume()
    }
    
    /// Add /categories?limit=999999 to server URL and call the API
    /// - Parameter completion: closure called after the request is finished, with list of categories if successfull, or with nil if not
    func getCategories(completion: @escaping (_ categories: [Category]?) -> Void) {
        get("categories", completion: completion)
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
    
    /// Get  items with given ids
    /// - Parameters:
    ///   - ids: items ids
    ///   - completion: closure called when request is finished, with items if successfull, or with nil if not
    func getItems(_ ids: [String], completion: @escaping ([Item]?) -> Void) {
        let parameters = [ "id": "in.(\(ids.joined(separator: ",")))"]
        get("items", parameters: parameters, completion: completion)
    }
    
    /// Add /items?categoryId=in.(..., ...)&vendor=in.(..., ...)&limit=... to server URL and call the API
    /// - Parameters:
    ///   - categories: the list of categories to filter items by, should not be empty
    ///   - gender: load female. male, or other (all) items
    ///   - vendors: the list of vendors to filter items by
    ///   - completion: closure called when request is finished, with the list of items if successfull, or with nil if not
    func getItems(
        in categories: [Category],
        for gender: Gender?,
        filteredBy vendors: [String] = [],
        completion: @escaping ([Item]?) -> Void)
    {
        // Prepare parameters
        let parameters = getParameters(in: categories, for: gender, filteredBy: vendors)
        
        // Request the items in the current category
        get("items", parameters: parameters, completion: completion)
    }
    
    /// Prepare parameters dictionary for given categories, gender, and vendors
    /// - Parameters:
    ///   - categories: the list of categories to filter items by
    ///   - gender: load female, male, or other items
    ///   - vendors: the list of vendors to filter items by
    /// - Returns: dictionary with parameters suitable to call get()
    func getParameters(
        in categories: [Category] = [],
        for gender: Gender?,
        filteredBy vendors: [String] = []
    ) -> [String: Any] {
        // Prepare parameters
        var parameters: [String: Any] = ["limit": Item.maxCount]
        parameters["category_id"] = categories.isEmpty ? nil : "in.(\(categories.map { "\($0.id)" }.joined(separator: ",")))"
        
        // Make vendors alphanumeric and lowercased
        let lowercasedVendors = vendors.map { $0.lowercased().components(separatedBy: .alphanumerics.inverted).joined() }
        parameters["vendor"] = vendors.isEmpty ? nil : "in.(\(lowercasedVendors.joined(separator: ",")))"
        
        // Add gender to parameters
        if let gender = gender {
            let genders = [gender == .other ? "\(Gender.male),\(Gender.female)" : gender.rawValue, "\(Gender.other)"]
            parameters["gender"] = "in.(\(genders.joined(separator: ",")))"
        }
        
        return parameters
    }
    
    /// Load (or reload) items from the server first time or when something has changed
    /// - Parameters:
    ///   - gender: gender to load the items for
    ///   - completion: closure called when all requests are finished, with true if successfull or false otherwise
    func reloadItems(for gender: Gender?, completion: @escaping (Bool?) -> Void) {
        // Load items if none are found
        ItemManager.shared.loadItems(for: gender, completion: completion)
    }
    
    /// Update the main url we have to use in the future
    /// - Parameter completion: closure called when request is finished, with true if request is succesfull, and false if not
    func updateURL(completion: @escaping (_ success: Bool) -> Void) {
        get("server") { (server: Server?) in
            guard let server = server else {
                debug("ERROR: Can't find server in \(String(describing: server))")
                completion(false)
                return
            }
            
            // Update server URL and logger's should log
            self.url = server.url
            Logger.shouldLog = server.shouldLog ?? false
            debug("INFO: Updated server to \(server.url) and `should log` to \(Logger.shouldLog)")
            
            completion(true)
        }
    }
}
