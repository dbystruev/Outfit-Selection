//
//  SignupButton.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

/// SignupButton selection buttons
class SignupButton: UIButton {
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
