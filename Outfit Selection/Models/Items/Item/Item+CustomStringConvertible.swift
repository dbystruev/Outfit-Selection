//
//  Item+CustomStringConvertible.swift/Users/dbystruev/Documents/GetOutfit/Xcode/Outfit-Selection/.gitignore
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Item: CustomStringConvertible {
    var description: String {
        "\(id): \(name) by \(vendorName)"
    }
}
