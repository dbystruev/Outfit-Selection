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
    /// Button's title
    private(set) var title: String?
    
    // MARK: - Init
    /// Init with occasion title
    /// - Parameter title: the occasion title to init with
    init(_ occasion: Occasion) {
        super.init(frame: CGRect.zero)
        set(occasion: occasion)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    /// Get button's occasion for given gender
    /// - Parameter gender: the gender to return occasion for
    /// - Returns: the button occasion for given gender
    func occasion(for gender: Gender?) -> Occasion? {
        title == nil ? nil : Occasions.with(title: title!).gender(gender).randomElement()
    }
    
    /// Set button's occasion
    /// - Parameter occasion: occasion to set
    func set(occasion: Occasion) {
        setTitle(occasion.label, for: .normal)
        title = occasion.title
    }
}
