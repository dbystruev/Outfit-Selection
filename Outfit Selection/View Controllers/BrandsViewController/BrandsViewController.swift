//
//  BrandsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandsViewController: UIViewController {
    
    // MARK: - Outlets
    /// Collection view with brand logos
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    /// Go button at the bottom of the screen
    @IBOutlet weak var getOutfitButton: UIButton!
    
    // MARK: - Stored Properties
    /// Gender selected on gender selection screen
    var gender: Gender? {
        get { Gender.current }
        set {
            // Don't clear items if gender value did not change
            guard Gender.current != newValue else { return }
            
            // Set current gender
            Gender.current = newValue
            
            // Clear all loaded items
            Item.removeAll()
            
            // Clear all wish lists
            Wishlist.removeAll()
        }
    }
    
    /// Flag which changes to true when all items are loaded from the server
    var allItemsLoaded = false
    
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    /// True if we should enable go button — either all items are loaded or timed out for refresh
    var shouldEnableGoButton = false {
        didSet {
            configureGoButton()
        }
    }
    
    // MARK: - Inherited Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show navigation bar on top
        navigationController?.isNavigationBarHidden = false
        
        // Load items if needed
        configureItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure brands collection view layout
        configureLayout()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        brandsCollectionView.reloadData()
    }
    
    // MARK: - Methods
    /// Set go button backgroun color and enable / disable it depending on number of brands selected
    func configureGoButton() {
        let brandsSelected = BrandManager.shared.selectedBrands.count
        let shouldEnable = 0 < brandsSelected && shouldEnableGoButton
        getOutfitButton.backgroundColor = shouldEnable ? #colorLiteral(red: 0.3205250204, green: 0.3743517399, blue: 0.3797602355, alpha: 1) : #colorLiteral(red: 0.638679564, green: 0.6545599103, blue: 0.6587830186, alpha: 1)
        getOutfitButton.isEnabled = shouldEnable
    }
    
    /// Start loading items from the server
    func configureItems() {
        // Check that there are no loaded items
        allItemsLoaded = 0 < Item.all.count
        guard !allItemsLoaded else { return }
        
        // Load items if none are found
        shouldEnableGoButton = false
        ItemManager.shared.loadItems(filteredBy: gender) { success in
            // Update the title for go button
            self.allItemsLoaded = success == true
            let title = self.allItemsLoaded ? "Get Outfit" : "Reload"
            
            // Enable go button when all items are loaded or reload is needed
            DispatchQueue.main.async {
                self.getOutfitButton.setTitle(title, for: .normal)
                self.shouldEnableGoButton = true
            }
        }
    }
    
    /// Configure brands collection view layout
    func configureLayout() {
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        brandsCollectionView.register(BrandCell.nib, forCellWithReuseIdentifier: BrandCell.reuseId)
        configureGoButton()
    }
}
