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
    func snap(_ scrollView: UIScrollView) {
        guard let stackView = scrollView.subviews.first as? UIStackView else { return }
        let numberOfSubviews = stackView.arrangedSubviews.count
        let subviewWidth = scrollView.contentSize.width / CGFloat(numberOfSubviews)
        guard 0 < subviewWidth else { return }
        let subviewIndex = round(scrollView.contentOffset.x / subviewWidth)
        UIView.animate(withDuration: 0.5) {
            scrollView.contentOffset.x = subviewWidth * subviewIndex
        }
    }
}
