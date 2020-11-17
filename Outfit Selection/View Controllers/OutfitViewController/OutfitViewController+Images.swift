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
            var count = scrollView.count
            let offers = Item.all.filter { $0.categoryId == category.id }
            for offer in offers {
                guard let url = offer.pictures?.first else { continue }
                NetworkManager.shared.getImage(url) { image in
                    guard let image = image else { return }
                    guard let itemIndex = offer.itemIndex else  {
                        debug("ERROR: Can't get item index for offer", offer.name, offer.url)
                        return
                    }
                    DispatchQueue.main.async {
                        scrollView.insert(image: image).tag = itemIndex
                        scrollView.scrollToLastElement() {_ in
                            if (0 < count) {
                                scrollView.deleteImageView(withIndex: 0)
                                count -= 1
                            }
                            self.updateItemCount()
                        }
                    }
                }
            }
        }
    }
}
