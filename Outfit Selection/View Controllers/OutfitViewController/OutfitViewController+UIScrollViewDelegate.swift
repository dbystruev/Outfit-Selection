//
//  ViewController+UIScrollViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIScrollViewDelegate
extension OutfitViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate { return }
        guard let pinnableScrollView = scrollView as? PinnableScrollView else { return }
        pinnableScrollView.scrollToCurrentElement()
        updatePrice()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let pinnableScrollView = scrollView as? PinnableScrollView else { return }
        pinnableScrollView.scrollToCurrentElement()
        updatePrice()
    }
}
