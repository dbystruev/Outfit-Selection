//
//  Occasion+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 11.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Occasion: CustomStringConvertible {
    var description: String {
        "\(title)\(isSelected ? " selected" : "") \(categoryIDs) / \(corners)"
    }
}
