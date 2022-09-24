//
//  JSON.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 02.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

struct JSON {
    /// Global JSON decoder
    static let decoder = { () -> JSONDecoder in
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    /// Global JSON encoder
    static let encoder = { () -> JSONEncoder in
        let jsonEncoder = JSONEncoder()
        return jsonEncoder
    }()
}
