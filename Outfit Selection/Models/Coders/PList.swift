//
//  PList.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 08.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

struct PList {
    /// Global PList decoder
    static let decoder = { () -> PropertyListDecoder in
        let plistDecoder = PropertyListDecoder()
        return plistDecoder
    }()
    
    /// Global PList encoder
    static let encoder = { () -> PropertyListEncoder in
        let plistEncoder = PropertyListEncoder()
        return plistEncoder
    }()
}
