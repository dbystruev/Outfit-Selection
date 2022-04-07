//
//  AccountCollectionViewCell.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cursorImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Methods
    /// Configure gender cell with given gender
    /// - Parameters:
    ///   - gender: the gender to confiture cell with
    ///   - selected: gender which is currently selected
    ///   - cursor: hide or show cursor
    func configure(titleLabel: String, label: String, cursor: Bool) {
        self.titleLabel.text = titleLabel
        self.label.text = label
        self.cursorImage.isHidden = !cursor
    }
}
