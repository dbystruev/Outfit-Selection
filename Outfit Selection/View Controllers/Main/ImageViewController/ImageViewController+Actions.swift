//
//  ImageViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension ImageViewController {
    // MARK: - Methods
    @objc func doubleTapped() {
        tapped
        ? imageScrollView.setZoomScale(imageScrollView.zoomScale + maximumZoomScale, animated: true)
        : imageScrollView.setZoomScale(minimumZoomScale, animated: true)
        tapped.toggle()
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
