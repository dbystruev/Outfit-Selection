//
//  ImageCollectionViewModels.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias ImageCollectionViewModels = [ImageCollectionViewModel]

extension ImageCollectionViewModels: ItemSearchable {
    /// Items stored in all view models
    var corneredItems: [Items] {
        map { $0.items }
    }
    
    /// All items in all view models
    var items: Items {
        flatMap { $0.items }
    }
}
