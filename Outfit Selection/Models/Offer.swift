//
//  Offer.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

struct Offer: Codable {
    static var all = [Offer]()
    
    let name: String
    let pictures: [URL]
    let url: URL
}
