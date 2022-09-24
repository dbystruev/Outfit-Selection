//
//  Dictionary+index.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
// Accessing keys and values in dictionary by index
extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
