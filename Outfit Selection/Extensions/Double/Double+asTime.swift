//
//  Double+asTime.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

extension Double {
    var asTime: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? self.description
    }
}
