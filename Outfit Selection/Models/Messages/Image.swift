//
//  Image.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import MessageKit
import UIKit

/// MediaItem Image
public struct Image: MediaItem {
    // MARK: - MediaItem Public Properties
    /// Image URL
    public var url: URL?
    
    /// Actual image
    public var image: UIImage?
    
    /// Placeholder image displayed while actual image is being obtained
    public var placeholderImage = UIImage()
    
    /// Size of the actual image
    public var size = CGSize.zero
    
    // MARK: - Init
    /// Creates an Image instance from the provided UIImage
    init(_ image: UIImage) {
        self.image = image
        self.size = image.size
    }
    
    /// Creates an Image instance from the specified named asset
    init?(named name: String) {
        guard let image = UIImage(named: name) else { return nil }
        self.init(image)
    }
}
