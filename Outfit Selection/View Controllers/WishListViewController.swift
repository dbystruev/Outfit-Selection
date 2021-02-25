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
    /// True when items tab is selected, false when outfits tab is selected
    var itemsTabSelected = true {
        didSet { updateUI() }
    }
    
    // MARK: - Custom Methods
    /// Update items or outfits displayed depending on items selected state
    func updateUI() {
        // Update buttons visibility
        itemsButton.titleLabel?.alpha = itemsTabSelected ? 1 : 0.5
        itemsUnderline.isHidden = !itemsTabSelected
        outletsButton.titleLabel?.alpha = itemsTabSelected ? 0.5 : 1
        outletsUnderline.isHidden = itemsTabSelected
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        wishlistCollectionView.dataSource = self
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction func itemsButtonTapped(_ sender: UIButton) {
        itemsTabSelected = true
    }
    
    @IBAction func outfitsButtonTapped(_ sender: UIButton) {
        itemsTabSelected = false
    }
}

extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { wishlist.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: wishlistCellId, for: indexPath)
        let wishlistElement = wishlist[indexPath.row]
        if let itemCell = cell as? ItemCell, let item = wishlistElement.item {
            itemCell.configure(with: item)
        }
        return cell
    }
    
    
}
