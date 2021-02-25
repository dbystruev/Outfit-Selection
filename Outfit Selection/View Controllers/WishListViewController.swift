//
//  WishlistViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var itemsButton: UIButton!
    @IBOutlet weak var itemsUnderline: UIView!
    @IBOutlet weak var outletsButton: UIButton!
    @IBOutlet weak var outletsUnderline: UIView!
    
    // MARK: - Properties
    /// True when items selected, false when outfits are selected
    var itemsSelected = true {
        didSet { updateUI() }
    }
    
    // MARK: - Custom Methods
    /// Update items or outfits displayed depending on items selected state
    func updateUI() {
        // Update buttons visibility
        itemsButton.titleLabel?.alpha = itemsSelected ? 1 : 0.5
        itemsUnderline.isHidden = !itemsSelected
        outletsButton.titleLabel?.alpha = itemsSelected ? 0.5 : 1
        outletsUnderline.isHidden = itemsSelected
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction func itemsButtonTapped(_ sender: UIButton) {
        itemsSelected = true
    }
    
    @IBAction func outfitsButtonTapped(_ sender: UIButton) {
        itemsSelected = false
    }
}
