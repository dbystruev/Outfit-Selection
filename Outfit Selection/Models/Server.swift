//
//  Server.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct Server: Codable {
    /// Whether the network requests should be remembered (cached) and not performed twice
    var shouldLog: Bool?
    
    /// New server URL
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url = "server"
        case shouldLog = "should_log"
    }
}
