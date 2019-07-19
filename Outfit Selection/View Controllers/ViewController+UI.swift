//
//  ViewController+UI.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UI
extension ViewController {
    func getScreenshot(of view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func setupUI() {
        scrollViews.forEach {
            $0.minimumZoomScale = zoomScale
            $0.maximumZoomScale = zoomScale
            $0.zoomScale = zoomScale
        }
        
        let logoImage = UIImage(named: "logo")
        print(#line, #function, logoImage)
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonPressed(_:)))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let diceImage = UIImage(named: "dice")
        let diceItem = UIBarButtonItem(image: diceImage, style: .plain, target: self, action: #selector(diceButtonPressed(_:)))
        
        setToolbarItems([deleteItem, spaceItem, diceItem], animated: false)
    }
}
