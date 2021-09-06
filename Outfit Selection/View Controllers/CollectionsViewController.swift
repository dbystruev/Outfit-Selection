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
    @IBOutlet weak var addItemsButtonBottomConstraint: NSLayoutConstraint!
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
    
    // MARK: - Inherited Properties
    override var keyboardObject: Any? { addItemsButtonBottomConstraint }
    override var keyboardTextField: UITextField? { nameTextField }
    
    // MARK: - Stored Properties
    /// Items which potentially could be added to newly created collection if the user selects them
    var collectionItems: [CollectionItem] = []
    
    // MARK: - Inherited Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nameTextField.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Stretch space in case we are in landscape (horizontal) mode
        let isHorizontal = size.height < size.width
        labelBottomConstraint.constant = isHorizontal ? 24 : 72
        labelTopConstraint.constant = isHorizontal ? 24 : 104
    }
    
    // MARK: - Actions
    @IBAction func addItemsButtonTapped(_ sender: UIButton) {
        nameTextField.endEditing(true)
        
        // Check that we have non-empty name
        guard let collectionName = nameTextField.text, !collectionName.isEmpty else {
            debug("Collection name is empty")
            dismiss(animated: true)
            return
        }
        
        // Check that we have a new collection prepared
        guard !collectionItems.isEmpty else {
            debug("No new collection available")
            dismiss(animated: true)
            return
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
