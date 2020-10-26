//
//  URL+withQueries.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String: Any]) -> URL {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return self }
        
        urlComponents.queryItems = queries.compactMap {
            URLQueryItem(name: $0.key, value: ($0.value as? Int)?.description ?? $0.value as? String)
        }
        
        return urlComponents.url ?? self
    }
}
