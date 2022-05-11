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
    static let defaultURL = URL(string: "http://oracle.getoutfit.net:3000")!
    static let shared = NetworkManager()
    
    // MARK: - Stored Properties
    /// Maximum number of simultaneous get requests (image loading is not counted)
    let requestsLimit = 2048
    
    /// The maximum number of parallel requests reached
    var requestsReached = 0
    
    /// The maximum number of parallel requests recommended
    let requestsRecommended = 16
    
    /// Number of get requests currently running (image loading is not counted)
    var requestsRunning = 0 {
        didSet {
            if requestsRunning < 1 {
                debug("Max:", requestsReached)
                requestsReached = 0
            } else {
                requestsReached = max(requestsReached, requestsRunning)
            }
        }
    }
    
    /// API server URL
    var url: URL
    
    /// Map short vendor names to full vendor names
    var fullVendorNames: [String: String] = {
        var fullVendorNames: [String: String] = [:]
        BrandManager.shared.brandNames.forEach { fullVendorNames[$0.shorted] = $0 	}
        return fullVendorNames
    }() {
        didSet {
            guard oldValue.keys.count != fullVendorNames.keys.count else { return }
            Items.updateVendorNames(with: fullVendorNames)
            Wishlist.updateVendorNames(with: fullVendorNames)
        }
    }
    
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
    /// Call items API and return all count items
    /// - Parameters:
    ///   - parameters: API query parameters
    ///   - header: header name for seacher
    ///   - completion: closure called when request is finished, witn count if successfull, or with nil if not
    func exactCount(with parameters: [String: Any], header: String, completion: @escaping (Int?) -> Void) {
        // Process get request
        head("items", parameters: parameters, header: header) { [weak self] (item: String?) in
            // Check for self availability
            guard self != nil else {
                debug("ERROR: self is not available")
                completion(nil)
                return
            }
            completion(Int(item?.lastComponent ?? "0"))
        }
    }
    
    /// Send get request with parameters and call completion when done
    /// - Parameters:
    ///   - path: path to add to server URL
    ///   - parameters: query parameters to add to request
    ///   - serverURL: use serverURL for request if not nil, otherwise use self.url
    ///   - completion: closure called after request is finished, with data if successfull, or with nil if not
    func get<T: Codable>(
        _ path: String,
        parameters: [String: Any] = [:],
        from serverURL: URL? = nil,
        completion: @escaping (T?) -> Void
    ) {
        
        // Compose the request URL
        let requestPath = (serverURL ?? url).appendingPathComponent(path)
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
        guard requestsRunning <= requestsLimit else {
            debug("ERROR: the number of network get requests should not exceed \(requestsLimit)")
            completion(nil)
            return
        }
        
        requestsRunning += 1
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                completion(nil)
                return
            }
            
            self.requestsRunning -= 1
            
            // Check if we haven't received nil
            guard let data = data else {
                let message = error?.localizedDescription ?? "No data"
                debug("ERROR requesting \(request): \(message)")
                completion(nil)
                return
            }
            
            // Decode the received data
            guard let decodedData: T = self.decode(data) else {
                debug("ERROR decoding response to \(request) \(data)")
                completion(nil)
                return
            }
            
            // Store the message in logger cache
            let message = String(data: data, encoding: .utf8)
            Logger.log(key: request.absoluteString, message)
            //debug(request.absoluteURL)
            completion(decodedData)
        }
        
        task.resume()
    }
    
    /// Send head request with parameters and call completion when done
    /// - Parameters:
    ///   - path: path to add to server URL
    ///   - parameters: query parameters to add to request
    ///   - header: header name for seacher
    ///   - completion: closure called after request is finished, with value from header if successfull, or with nil if not
    func head<T: Codable>(_ path: String, parameters: [String: Any] = [:], header: String, completion: @escaping (T?) -> Void) {
        
        // Compose the request URL
        let requestPath = url.appendingPathComponent(path)
        let request = parameters.isEmpty ? requestPath : requestPath.withQueries(parameters)
        
        // Configure URLSession
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Prefer": "count=exact"]
        
        // Check that we don't run more than allowed number of get requests in parallel
        guard requestsRunning <= requestsLimit else {
            debug("ERROR: the number of network get requests should not exceed \(requestsLimit)")
            completion(nil)
            return
        }
        
        requestsRunning += 1
        
        // Make URLSession with configuration
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { [weak self] _, response, error in
            
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                completion(nil)
                return
            }
            
            self.requestsRunning -= 1
            
            // Cast response to HTTPURLResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                debug("ERROR: response is not HTTPURLResponse")
                completion(nil)
                return
            }
            
            // Get value from name header
            guard let itemHeader = httpResponse.allHeaderFields[header] as? String else {
                debug("ERROR: httpResponse is not contain \(header)")
                completion(nil)
                return
            }
            completion(itemHeader as? T)
        }
        task.resume()
    }
    
    /// Call /categories API
    /// - Parameter completion: closure called after the request is finished, with list of categories if successfull, or with nil if not
    func getCategories(completion: @escaping (_ categories: Categories?) -> Void) {
        get("categories", completion: completion)
    }
    
    /// Call /feeds API
    /// - Parameter completion: closure called after the request is finished, with list of feeds if successfull, or with nil if not
    func getFeeds(completion: @escaping (_ feeds: FeedsProfile?) -> Void) {
        get("feeds", completion: completion)
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
    
    /// Get  items with given IDs
    /// - Parameters:
    ///   - IDs: items IDs
    ///   - completion: closure called when request is finished, with items if successfull, or with nil if not
    func getItems(_ IDs: [String], completion: @escaping (Items?) -> Void) {
        // Current selected feedsProfile
        let feed = [String](FeedsProfile.all.selected.feedsIDs)
        
        let feedParameter = FeedsProfile.all.isEmpty ? nil : ["feed": "in.(\(feed.commaJoined))"]

        // Include id=in.(..., ...) parameter
        var parameters = ["id": "in.(\(IDs.commaJoined))"]
        
        // Include feed=in.(..., ...) parameter
        parameters.merge(feedParameter ?? [:]) { (_, new) in new }
        
        debug(parameters)
        
        // Request the items from the API
        getItems(with: parameters) { items in
            guard let items = items else {
                completion(nil)
                return
            }
            
            let orderedItems = IDs.compactMap { id in
                items.first { $0.id == id }
            }
            
//            // For DEBUG
//            for orderedItem in orderedItems {
//                debug(orderedItem.feed)
//            }

            completion(orderedItems)
        }
    }

    /// Add /items?category_id=in.(..., ...)&vendor=in.(..., ...)&limit=... to server URL and call the API
    /// - Parameters:
    ///   - gender: load female. male, or other (all) items, Gender.current by default
    ///   - categoryIDs: the list of category IDs to filter items by, empty (all categories) by default
    ///   - subcategoryIDs: the list of subcategory IDs to filter items by, empty (all subcategories) by default
    ///   - vendorNames: the list of vendors to filter items by
    ///   - feeds: the feeds profile selected IDs by default
    ///   - limit: limit the number of items by given number, nil by default
    ///   - sale: old price should not be null, false by default
    ///   - completion: closure called when request is finished, with the list of items if successfull, or with nil if not
    func getItems(
        for gender: Gender? = Gender.current,
        in categoryIDs: [Int] = [],
        subcategoryIDs: [Int] = [],
        filteredBy vendorNames: [String] = [],
        feeds: [String] = [String](FeedsProfile.all.selected.feedsIDs),
        limited limit: Int? = nil,
        named name: String? = nil,
        sale: Bool = false,
        completion: @escaping (Items?) -> Void)
    {
        // Prepare parameters
        let parameters = parameters(
            for: gender,
            in: categoryIDs,
            subcategoryIDs: subcategoryIDs,
            named: name,
            feed: feeds,
            limited: limit,
            sale: sale,
            filteredBy: vendorNames
        )
        
        // Request the items from the API
        getItems(with: parameters, completion: completion)
    }
    
    /// Call items API and replace vendor names in items with full versions after the call
    /// - Parameters:
    ///   - parameters: API query parameters
    ///   - completion: closure called when request is finished, with the list of items if successfull, or with nil if not
    func getItems(with parameters: [String: Any], offset: Int = 0, completion: @escaping (Items?) -> Void) {
        // Sort by modified time from newest to oldest
        var parameters = parameters
        parameters["order"] = "modified_time.desc"
        
        if offset != 0 {
            parameters["offset"] = "\(offset)"
        }
        
        // Process get request
        get("items", parameters: parameters) { [weak self] (items: Items?) in
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                completion(nil)
                return
            }
            
            self.restoreVendorFullNames(items: items, completion: completion)
        }
    }
    
    /// Call /occasions API
    /// - Parameters:
    ///   - IDs: the list of occasion IDs to get, if nil (default) — get all
    ///   - completion: closure called after the request is finished, with list of occasions if successfull, or with nil if not
    func getOccasions(_ IDs: [Int]? = nil, completion: @escaping (_ occasions: Occasions?) -> Void) {
        // Include id=in.(..., ...) parameter
        let parameters = IDs == nil || IDs?.count == 0 ? [:] : ["id": "in.(\((IDs ?? []).commaJoined))"]
        
        get("occasions", parameters: parameters) { (occasions: Occasions?) in
            occasions?.forEach {
                // Remove non-latin characters from the beginning of the name
                $0.name = $0
                    .name
                    .replacingOccurrences(
                        of: "^[^a-z0-9]*",
                        with: "",
                        options: [.caseInsensitive, .regularExpression]
                    )
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Remove anything in brackets inside the labels and non-lating characters from the end
                $0.label = $0
                    .label
                    .replacingOccurrences(
                        of: #"\(.*\)"#,
                        with: "",
                        options: [.regularExpression]
                    )
                    .replacingOccurrences(
                        of: "[^a-z0-9]*$",
                        with: "",
                        options: [.caseInsensitive, .regularExpression]
                    )
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            completion(occasions)
        }
    }
    
    /// Call /onboarding API
    /// - Parameter completion: closure called after the request is finished, with list of occasions if successfull, or with nil if not
    func getOnboarding(completion: @escaping (_ onboardings: [Onboarding]?) -> Void) {
        get("onboarding", completion: completion)
    }
    
    /// Prepare parameters dictionary for given categories, gender, and vendors
    /// - Parameters:
    ///   - gender: load female, male, or other items
    ///   - categories: the list of category IDs to filter items by, empty (all categories) by default
    ///   - subcategories: the list of subcategory IDs to filter items by, empty (all subcategories) by default
    ///   - limit: limit the number of items by given number, nil by default
    ///   - sale: old price should not be null
    ///   - fullVendorNames: the list of vendors to filter items by
    /// - Returns: dictionary with parameters suitable to call get()
    func parameters(
        for gender: Gender?,
        in categories: [Int],
        subcategoryIDs: [Int],
        named name: String?,
        feed: [String],
        limited limit: Int?,
        sale: Bool,
        filteredBy fullVendorNames: [String]
    ) -> [String: Any] {
        // Alias Item.CodingKeys for shorter code
        typealias Keys = Item.CodingKeys
        
        // Prepare parameters
        var parameters: [String: Any] = [
            "limit": limit ?? Items.maxCornerCount
        ]
        
        // Add "category_id=in.(1,2,3)" parameter
        parameters[Keys.categoryID.rawValue] = categories.isEmpty
        ? nil
        : "in.(\([Int](categories.uniqued()).commaJoined))"
        
        // Add "categories=ov.{1,2,3}" parameter (ov for overlap)
        parameters[Keys.subcategoryIDs.rawValue] = subcategoryIDs.isEmpty
        ? nil
        : "ov.{\([Int](subcategoryIDs.uniqued()).commaJoined)}"
        
        // Add "old_price" not null parameter
        parameters[Keys.oldPrice.rawValue] = sale ? "not.is.null" : nil
        
        // Make vendors alphanumeric and lowercased
        let shortVendorNames: [String] = fullVendorNames.map { fullVendorName in
            let shortVendorName = fullVendorName.shorted
            self.fullVendorNames[shortVendorName] = fullVendorName
            return shortVendorName
        }
        
        // Add "vendor" parameter
        parameters[Keys.vendorName.rawValue] = fullVendorNames.isEmpty
        ? nil
        : "in.(\([String](shortVendorNames.uniqued()).commaJoined))"
        
        // Add "gender" parameter
        if let gender = gender {
            let genders = [gender == .other ? "\(Gender.male),\(Gender.female)" : gender.rawValue, "\(Gender.other)"]
            parameters[Keys.gender.rawValue] = "in.(\(genders.commaJoined))"
        }
        
        // Add "name" parameter
        if let name = name {
            parameters[Keys.name.rawValue] = "ilike.*\(name)*"
        }
        
        // Add "feed" parameter
        parameters[Keys.feed.rawValue] = FeedsProfile.all.isEmpty ? nil : "in.(\(feed.commaJoined))"
        return parameters
    }
    
    /// Load (or reload) items from the server first time or when something has changed
    /// - Parameters:
    ///   - gender: gender to load the items for
    ///   - occasion: occasion to load the items for
    ///   - completion: closure called when all requests are finished, with true if successfull or false otherwise
    func reloadItems(
        for gender: Gender? = nil,
        from occasion: Occasion? = nil,
        completion: @escaping (Bool?) -> Void
    ) {
        
        // Get occasions with the same title and given gender
        lazy var selectedOccasions = Occasions
            .selectedUniqueTitle
            .gender(gender)
            .sorted(by: { $0.label < $1.label })
        lazy var newOccasion = selectedOccasions.randomElement()
        
        // Don't change occasion if gender is the same, do change for different gender
        let oldOccasion = Occasion.selected
        Occasion.selected = occasion
        ?? (gender == oldOccasion?.gender || gender == .other ? oldOccasion ?? newOccasion : newOccasion)
        
        // Load items if none are found
        ItemManager.shared.loadItems(for: Occasion.selected, completion: completion)
    }
    
    /// Restore full names for item vendors using self.fullVendorNames dictionary
    /// - Parameters:
    ///   - items: iterms with short vendor names received from the API
    ///   - completion: closure called when full vendor names are restored, with items with replaced vendor names
    func restoreVendorFullNames(items: Items?, completion: @escaping (Items?) -> Void) {
        guard let items = items else {
            completion(nil)
            return
        }
        
        // API sends short vendor names, replace them with full names
        items.forEach { item in
            item.vendorName = self.fullVendorNames[item.vendorName] ?? item.vendorName
        }
        
        completion(items)
    }
    
    /// Update the main url depending on which server responds the first to the user
    /// - Parameter completion: closure called when request is finished, with true if request is succesfull, and false if not
    func updateURL(completion: @escaping (_ success: Bool) -> Void) {
        // Flag when the server is found to drop the rest
        var updated = false
        
        // Go through all available servers and try to get data from them
        for server in Servers.all {
            get("servers", from: server.url) { [weak self] (servers: Servers?) in
                // Check that we got any response
                guard servers != nil else {
                    debug("WARNING: Can't connect to server \(server.name)")
                    // Don't call completion — let other servers to finish
                    return
                }
                
                // Check that server was not updated yet
                // Don't call completion — if guard fails it was already called ealier
                guard !updated else { return }
                updated = true
                
                // Update server URL and logger's should log
                self?.url = server.url
                debug("INFO: Updated server to \(server.url)")
                
                completion(true)
            }
        }
    }
}
