//
//  UIImage+resize.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIImage {
    /// Returnes image resized twice on each side, i. e. with 4 times less square
    var halved: UIImage {
        resized(to: CGSize(width: size.width / 2, height: size.height / 2))
    }
    
    /// Returns image resized to given size
    /// - Parameter size: size of the new image
    /// - Returns: resized image
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(origin: CGPoint(), size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
