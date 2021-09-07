//
//  WishlistBaseCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WishlistBaseCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: - Stored Properties
    /// Delegate to send select button message
    var delegate: ButtonDelegate?
    
    /// Item or outfit currently being displayed
    var element: Any?
    
    // MARK: - Inherited Properties
    /// Changes button appearance when this cell is selected
    override var isSelected: Bool {
        get { super.isSelected }
        set {
            super.isSelected = newValue
            selectButton.isSelected = newValue
        }
    }
    
    // MARK: - Methods
    /// Save delegate and element of this cell
    /// - Parameters:
    ///   - element:  element to configure cell content with
    ///   - delegate: delegate to send message about select button tap, nil by default
    func configure(with element: Any?, delegate: ButtonDelegate?) {
        // Save the delegate and the element
        self.delegate = delegate
        self.element = element
        
        // Don't show the button if there is no delegate or element
        selectButton.isHidden = delegate == nil || element == nil
    }
    
    // MARK: - Actions
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(self)
    }
}
