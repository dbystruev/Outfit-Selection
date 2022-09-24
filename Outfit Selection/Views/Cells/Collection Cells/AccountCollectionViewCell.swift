//
//  AccountCollectionViewCell.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 05.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    /// Optional disclosure image view on the cell's right
    @IBOutlet weak var disclosureImageView: UIImageView!
    
    /// The label on cell's left
    @IBOutlet weak var fieldNameLabel: UILabel!
    
    /// The label in the middle of the cell
    @IBOutlet weak var textLabel: UILabel!
    
    // MARK: - Methods
    /// Configure gender cell with given gender
    /// - Parameters:
    ///   - fieldName: text for the cell's left
    ///   - text: text for the middle of the cell (default: "")
    ///   - disclosure: should show disclosure indicator (default: false)
    func configure(_ fieldName: String, text: String = "", disclosure: Bool = false) {
        disclosureImageView.isHidden = !disclosure
        fieldNameLabel.text = fieldName
        textLabel.text = text
    }
}
