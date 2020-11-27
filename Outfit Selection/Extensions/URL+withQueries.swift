//
//  URL+withQueries.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

extension URL {
    /// Add queries as parameters to URL for get request
    /// - Parameter queries: the dictionary of key: value to append to URL
    /// - Returns: URL with queries added or self in case of error
    func withQueries(_ queries: [String: Any]) -> URL {
        // Split URL into the components
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return self }
        
        // Array where we will accumulate URL query items
        var queryItems: [URLQueryItem] = []
        
        // Go through all queries one by one
        for query in queries {
            // String representation of query value
            let value: String
            
            // Check if value is an Int
            if let intValue = query.value as? Int {
                value = "\(intValue)"
            // Check if value is a String
            } else if let stringValue = query.value as? String {
                value = stringValue
            // Check if value is array of Ints
            } else if let intArray = query.value as? [Int] {
                // Create temporary array of URL query items with the same key and different values
                let items = intArray.map { URLQueryItem(name: query.key, value: "\($0)") }
                
                // Append temporary array into the accumulating array of URL query items
                queryItems.append(contentsOf: items)
                
                // Value is not initialized, items already added — go to the next item in query
                continue
            } else if let stringArray = query.value as? [String] {
                // Create temporary array of URL query items with the same key and different values
                let items = stringArray.map { URLQueryItem(name: query.key, value: $0) }
                
                // Append temporaty array into the accumulating array of URL query items
                queryItems.append(contentsOf: items)
                
                // Value is not initialized, items already added - go to the next item in the query
                continue
            } else {
                // Skip this query — no recognizable value is found
                continue
            }
            // Value is either a String or String converted from Int, append it to the accumulating array
            queryItems.append(URLQueryItem(name: query.key, value: value))
        }
        
        // Save accumulating array to the array of query items for the URL
        urlComponents.queryItems = queryItems
        
        // Return the new full URL including query items
        return urlComponents.url ?? self
    }
}
