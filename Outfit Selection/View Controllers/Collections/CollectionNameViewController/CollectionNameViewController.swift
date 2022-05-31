//
//  CollectionNameViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class CollectionNameViewController: CollectionBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var addItemsButton: UIButton!
    @IBOutlet weak var addItemsButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackView: UIStackView!
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
            
            // Set self as UITextFieldDelegate
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Private Properties
    /// Gitle for Button Title
    private var addItemsButtonTitle: String?
    /// Status for this viewvController
    private var editMode = false
    /// Text for nameTextField
    private var name: String?
    // FeedItemViewController
    var feedItemViewController: FeedItemViewController?
 
    // MARK: - Inherited Properties
    override var keyboardObject: Any? { addItemsButtonBottomConstraint }
    override var keyboardTextField: UITextField? { nameTextField }
    
    // MARK: - Inherited Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nameTextField.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
        updateUI()
        saveButton.isEnabled = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editMode {
            addItemsButton.isHidden = true
            buttonsStackView.isHidden = false
            nameTextField.text = name
            
            // Short modal view Controller
            if #available(iOS 15.0, *) {
                if let presentationController = presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium(),.large()]
                    presentationController.prefersGrabberVisible = true
                }
            } 
        }
    }
    
    // MARK: - Custom Methods
    /// Configure saveButton and textField
    /// - Parameters:
    ///   - name: string for textField text
    func configure(textField name: String, sender: Any? ){
        editMode = true
        self.name = name
        feedItemViewController = sender as? FeedItemViewController
    }
    
    /// Show `add items button` when `name text field` is not empty
    func updateUI() {
        let isEnabled = nameTextField.text?.isEmpty == false
        addItemsButton.backgroundColor = isEnabled ? Global.Color.Button.enabled : Global.Color.Button.disabled
        addItemsButton.isEnabled = isEnabled
        saveButton.isEnabled = isEnabled
    }
    
}
