//
//  ViewController+Images.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 21/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Images
extension OutfitViewController {
    func loadImagesFromAssets() {
        // Image names are "\(prefix)01", "\(prefix)02" etc.
        for (prefix, scrollView) in zip(imagePrefixes, scrollViews) {
            for suffixCount in 1... {
                let suffix = String(format: "%02d", suffixCount)
                let imageName = "\(prefix)\(suffix)"
                guard let image = UIImage(named: imageName) else { break }
                scrollView.insert(image: image)
            }
        }
    }
    
    func loadImagesFromServer() {
        for (category, scrollView) in zip(Category.all, scrollViews) {
            let offers = Offer.all.filter { $0.categoryId == category.id }
            
        }
    }
}
