//
//  ItemImageView+configure.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 01.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension ItemImageView {
    /// Load image from URL
    /// - Parameter item: the Item to load image from
    func configure(with item: Item?) {
        
        // Get url fron item
        guard let url = item?.pictures.first else { return }
        
        // Set current item from item
        self.item = item
        
        // Download image
        NetworkManager.shared.getImage(url) { [weak self] newImage in
            guard let newImage = newImage else { return }
            
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                return
            }
            
            // Check item to equals
            guard self.item?.id == item?.id else {
                debug("WARNING:", item?.id, "changed to", self.item?.id)
                return
            }
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
    }
}
