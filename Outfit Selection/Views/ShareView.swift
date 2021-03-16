//
//  ShareView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ShareView: UIView {
    // MARK: - Outlets
    @IBOutlet var pictureImageViews: [UIImageView]!
    
    // MARK: - Class Functions
    class func instanceFromNib() -> ShareView {
        UINib(nibName: "\(Self.self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
    }
    
    // MARK: - Custom Functions
    /// Configure share view with the list of images
    /// - Parameter images: the list of images — from top to bottom, from left to right
    func configure(with images: [UIImage?]) {
        for (image, pictureImageView) in zip(images, pictureImageViews) {
            pictureImageView.image = image
        }
    }
}
