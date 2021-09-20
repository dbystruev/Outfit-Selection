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
    /// Top right button to clear or select all brands
    @IBOutlet weak var allButton: SelectableButtonItem!
    
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
            
            // Clear all wish lists
//            Wishlist.removeAll()
        }
    }
    
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
    /// Set top right button to clear or select all
    func configureAllButton() {
        allButton.isSelected = brandedImages.unselected.count < brandedImages.selected.count
    }
    
    /// Set go button backgroun color and enable / disable it depending on number of brands selected
    func configureGoButton() {
        let brandsSelected = BrandManager.shared.selectedBrands.count
        let isEnabled = 0 < brandsSelected
        getOutfitButton.backgroundColor = isEnabled ? Globals.Color.Button.enabled : Globals.Color.Button.disabled
        getOutfitButton.isEnabled = isEnabled
    }
    
    /// Configure brands collection view layout
    func configureLayout() {
        // Configure the brands collection view
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        brandsCollectionView.register(BrandCell.nib, forCellWithReuseIdentifier: BrandCell.reuseId)
        
        // Configure the buttons
        configureAllButton()
        configureGoButton()
    }
}
