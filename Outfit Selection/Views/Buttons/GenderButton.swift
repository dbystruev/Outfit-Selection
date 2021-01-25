//
//  GenderButton.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.01.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

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
}
