//
//  OccasionButton.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 11.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionButton: UIButton {
    // MARK: - Stored Properties
    /// Occasion this button is selecting
    weak var occasion: Occasion?
    
    // MARK: - Init
    init(_ occasion: Occasion) {
        super.init(frame: CGRect.zero)
        self.occasion = occasion
        setTitle(occasion.name, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
