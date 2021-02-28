//
//  GenderCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class GenderCell: UICollectionViewCell {
    // MARK: - Static Properties
    /// The nib object containing this cell
    static let nib = UINib(nibName: "GenderCell", bundle: nil)
    
    /// The reuse identifier to associate with this cell's nib file
    static let reuseId = "genderCell"
    
    // MARK: - Outlets
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    
    // MARK: - Methods
    /// Configure gender cell with given gender
    /// - Parameters:
    ///   - gender: the gender to confiture cell with
    ///   - selected: gender which is currently selected
    func configure(gender: Gender, selected: Gender?) {
        genderLabel.text = gender.rawValue.firstCapitalized
        radioImageView.isHidden = gender != selected
    }
}
