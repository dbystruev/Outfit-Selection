//
//  UIImageView+configure.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Load image from URL
    /// - Parameter url: the URL to load image from
    func configure(with url: URL?) {
        guard let url = url else { return }
        NetworkManager.shared.getImage(url) { [weak self] newImage in
            guard let newImage = newImage else { return }
            
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                return
            }
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
    }
}
