//
//  Server.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

public struct Server: Codable {
    /// E. g. "Oracle Cloud Amsterdam"
    let about: String?
    
    /// E. g. 1
    let id: Int
    
    /// E. g. "oracle.getoutfit.net"
    let name: String
    
    /// E. g. true
    let shouldUse: Bool
    
    /// E. g. http://oracle.getoutfit.net:3000
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case about
        case id
        case name
        case shouldUse = "in_use"
        case url
    }
}
