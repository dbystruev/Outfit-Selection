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
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    // MARK: - Computed Properties
    /// Either items or outfits wishlist depending on whether the items tab is selected
    var wishlist: [Wishlist] {
        itemsTabSelected ? Wishlist.items : Wishlist.outfits
    }
    
    /// Either items or outfit cell depending on whether the items tab is selected
    var wishlistCellId: String {
        itemsTabSelected ? "itemCell" : "outfitCell"
    }
    
    // MARK: - Stored Properties
    /// Number of cells to show per row: 2 for vertical and 4 for horizontal orientations
    var cellsPerRow = 2
    
    /// True when items tab is selected, false when outfits tab is selected
    var itemsTabSelected = true {
        didSet { updateUI() }
    }
    
    // MARK: - Custom Methods
    /// Select non-empty tab, but if both are empty or both are not empty do not change selected tab
    func selectNonEmptyTab() {
        let itemsCount = Wishlist.items.count
        let outfitsCount = Wishlist.outfits.count
        
        if itemsCount == 0 && 0 < outfitsCount {
            itemsTabSelected = false
        } else if 0 < itemsCount && outfitsCount == 0 {
            itemsTabSelected = true
        }
    }
    
    /// Update items or outfits displayed depending on items selected state
    func updateUI(isHorizontal: Bool? = nil) {
        // Set the number of cells per row
        let size = view.bounds.size
        let isHorizontal = isHorizontal ?? (size.height < size.width)
        cellsPerRow = isHorizontal ? 4 : 2
        
        // Update buttons visibility
        itemsButton.titleLabel?.alpha = itemsTabSelected ? 1 : 0.5
        itemsUnderline.isHidden = !itemsTabSelected
        outletsButton.titleLabel?.alpha = itemsTabSelected ? 0.5 : 1
        outletsUnderline.isHidden = itemsTabSelected
        
        // Reload collection view
        wishlistCollectionView.reloadData()
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectNonEmptyTab()
        updateUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(isHorizontal: size.height < size.width)
    }
    
    // MARK: - Actions
    @IBAction func itemsButtonTapped(_ sender: UIButton) {
        itemsTabSelected = true
    }
    
    @IBAction func outfitsButtonTapped(_ sender: UIButton) {
        itemsTabSelected = false
    }
}
