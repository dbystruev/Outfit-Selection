//
//  GenderButton.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.01.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// Gender selection buttons at gender selection screen
class GenderButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        layer.cornerRadius = 10
    }
    
    /// Fix the vertical alignment of button title by setting top edge inset margin of 7
    override func layoutSubviews() {
        super.layoutSubviews()
        if titleEdgeInsets == UIEdgeInsets.zero {
            titleEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        }
    }
}
