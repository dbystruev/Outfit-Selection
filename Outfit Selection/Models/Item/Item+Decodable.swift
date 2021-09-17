//
//  Item+Decodable.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension Item: Decodable {
    init(from decoder: Decoder) throws {
        // Get values from the container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each of the properties
        categoryId = try values.decode(Int.self, forKey: .categoryId)
        id = try values.decode(String.self, forKey: .id)
        modifiedTime = try? values.decode(Date.self, forKey: .modifiedTime)
        name = try values.decode(String.self, forKey: .name)
        oldPrice = try? values.decode(Double.self, forKey: .oldPrice)
        pictures = try values.decode([URL].self, forKey: .pictures)
        price = try values.decode(Double.self, forKey: .price)
        url = try values.decode(URL.self, forKey: .url)
        vendor = try values.decode(String.self, forKey: .vendor)
    }
}
