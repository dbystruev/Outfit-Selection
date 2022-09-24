//
//  Timestamp.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct Timestamp {
    /// Global timestamp formatter
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
}
