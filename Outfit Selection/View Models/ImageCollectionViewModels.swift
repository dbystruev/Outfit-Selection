//
//  ImageCollectionViewModels.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

typealias ImageCollectionViewModels = [ImageCollectionViewModel]

extension ImageCollectionViewModels {
    /// Items stored in all view models
    var items: [Items] {
        map { $0.items }
    }
}
