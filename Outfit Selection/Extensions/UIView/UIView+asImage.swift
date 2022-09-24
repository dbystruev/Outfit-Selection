//
//  UIView+asImage.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIView {
    /// Make screenshot of a  view
    /// - Returns: image which represents the view
    var asImage: UIImage {
        let size = frame.size
        
        // Get the renderer
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            // Draw the screenshot view
            drawHierarchy(in: CGRect(origin: CGPoint(), size: size), afterScreenUpdates: true)
        }
        
        return image
    }
}
