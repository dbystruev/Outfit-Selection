//
//  CollectionsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    /// Underlined text field where user enters collection name
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            // Underline text field
            let bottomLine = CALayer()
            bottomLine.backgroundColor = UIColor(red: 0.622, green: 0.675, blue: 0.668, alpha: 1).cgColor
            bottomLine.frame = CGRect(x: 0, y: nameTextField.bounds.height - 1, width: CGFloat(Int.max), height: 1)
            nameTextField.layer.addSublayer(bottomLine)
            nameTextField.layer.masksToBounds = true
            
            // Align text to the center
            nameTextField.contentVerticalAlignment = .top // actually default
            nameTextField.textAlignment = .center
        }
    }
    
    // MARK: - Static Properties
    static let segueIdentifier = "collectionsViewControllerSegue"
    
    // MARK: - Actions
    @IBAction func addItemsButtonTapped(_ sender: UIButton) {
        debug()
    }
}
