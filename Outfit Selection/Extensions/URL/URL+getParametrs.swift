//
//  URL+getParametrs.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 02.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//  https://stackoverflow.com/questions/41421686/get-the-value-of-url-parameters

import Foundation

extension URL {
    /// Add parameter name and URL to get result
    /// - Returns: Parametr from URL
    public var getParametrs: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
