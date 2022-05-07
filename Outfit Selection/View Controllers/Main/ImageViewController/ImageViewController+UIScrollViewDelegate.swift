//
//  ImageViewController+UIScrollViewDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
