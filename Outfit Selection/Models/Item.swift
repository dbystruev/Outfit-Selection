//
//  Item.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.10.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

struct Item: Codable {
    static var all = [Item]()
    static let maxCount = 24
    
    let categoryId: Int
    let name: String
    let pictures: [URL]
    let url: URL
}
