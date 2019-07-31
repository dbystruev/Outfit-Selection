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
    func loadImages() {
        for (folderImages, scrollView) in zip(images, scrollViews) {
            folderImages.forEach { scrollView.insert(image: $0) }
        }
    }
}
