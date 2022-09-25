//
//  APIKey.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 21.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

/// Cases used as keys for Global.apiKeys dictionary
public enum APIKey: String {
    case airtableApiKey
    case appleAppID
    case appsFlyerDevKey
    case telegramApiHash
    case telegramApiID
    case yandexAppMetricaKey
    
    /// Load Global.apiKeys from APIKeys.plist
    public static func load() {
        guard Global.apiKeys.isEmpty else {
            debug("WARNING: APIKeys.plist has been processed already")
            return
        }
        
        guard let apiURL = Bundle.main.url(forResource: "APIKeys", withExtension: "plist") else {
            debug("WARNING: APIKeys.plist is not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: apiURL)
            let apiDictionary = try PropertyListSerialization.propertyList(from: data, format: nil)
            guard let apiKeys = apiDictionary as? [String: String] else {
                debug("WARNING: Can't convert APIKeys.plist to [String: String]")
                return
            }
            for (key, value) in apiKeys {
                guard let apiKey = APIKey(rawValue: key) else {
                    debug("WARNING: Can't find \(key) in APIKey")
                    continue
                }
                Global.apiKeys[apiKey] = value
            }
            debug("Keys loaded from APIKeys.plist: \(Global.apiKeys.count)")
        } catch {
            debug("WARNING:", error.localizedDescription)
        }
    }
}
