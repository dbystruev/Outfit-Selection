//
//  GenderCollectionViewCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class GenderCollectionViewCell: UICollectionViewCell {
    // MARK: - Class Properties
    /// Nib name is the same as the class name
    class var nibName: String { String(describing: Self.self) }
    
    // MARK: - Static Properties
    /// The nib object containing this gender cell
    static let nib = UINib(nibName: nibName, bundle: nil)
    
    // MARK: - Outlets
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var radioImageView: UIImageView!
    
    // MARK: - Methods
    /// Configure gender cell with given gender
    /// - Parameters:
    ///   - gender: the gender to confiture cell with
    ///   - selected: gender which is currently selected
    func configure(gender: Gender, selected: Gender?) {
        genderLabel.text = gender == .other ? "Non-binary" : gender.rawValue.capitalizingFirstLetter
        radioImageView.isHidden = gender != selected
    }
}
