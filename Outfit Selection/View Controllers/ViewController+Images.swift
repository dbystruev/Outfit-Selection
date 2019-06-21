//
//  ViewController+Images.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 21/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Images
extension ViewController {
    func loadImages() {
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("Images.bundle")
        for (folder, scrollView) in zip(bundleFolders, scrollViews) {
            let folderURL = assetURL.appendingPathComponent(folder)
            let files = try! fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let imageNames = files.map({ $0.lastPathComponent }).sorted()
            let images = imageNames.compactMap { UIImage(named: "\(folder)/\($0)", in: Bundle(url: assetURL), compatibleWith: nil)}
            images.forEach { scrollView.insert(image: $0) }
        }
    }
}
