//
//  PickType+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension PickType: CustomStringConvertible {
    /// CustomStringConvertible
    var description: String {
        switch self {
        case .brand(let brandName):
            return ".brand(\(brandName))"
        case .brands:
            return ".brands"
        case .collections(let collectionName):
            return ".collections(\(collectionName))"
        case .occasion(let occasionName):
            return ".occasion(\(occasionName))"
        case .category(let categoryName):
            return ".category(\(categoryName))"
        case .daily(let limit):
            return ".daily(\(limit))"
        case .emptyBrands:
            return ".noBrands"
        case .hello:
            return ".hello"
        case .newItems:
            return ".newItems"
        case .occasions(let occasionID):
            return ".occasions(\(occasionID))"
        case .sale:
            return ".sale"
        }
    }
}
