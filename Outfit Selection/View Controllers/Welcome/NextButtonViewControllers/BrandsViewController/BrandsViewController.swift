//
//  BrandsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class BrandsViewController: NextButtonViewController {
    
    // MARK: - Outlets
    /// Top right button to clear or select all brands
    @IBOutlet weak var allButton: SelectableButtonItem!
    
    /// Collection view with brand logos
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    /// Search bar for the brands
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Discover thousands of brands"~
        }
    }
    
    // MARK: - Static Constants
    /// Time delay before closing search keybaord
    static let searchKeystrokeDelay: TimeInterval = 0.25
    
    // MARK: - Stored Properties
    /// The collection of brand images
    private(set) var brands: [Brand] = Brands.withImage.values.sorted()
    
    /// The saved collection of selected brands
    private(set) var savedBrands: [String] = []
    
    /// The string to filter brand search results
    var filterString = "" {
        didSet {
            Brands.filterString = filterString
            reloadBrands()
        }
    }
    
    /// Time of last click in search bar
    var lastClick: Date?
    
    /// True if we should enable go button — either all items are loaded or timed out for refresh
    var shouldEnableGoButton = false {
        didSet {
            configureNextButton()
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Clear brands search string when leaving brands selection screen
        filterString = ""
        searchBar.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure brands collection view layout
        configureLayout()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show navigation bar on top
        navigationController?.isNavigationBarHidden = false
        
        // Configure the buttons
        configureAllButton()
        
        // Reload data when coming from another tab
        brandsCollectionView.reloadData()
        
        // If viewControllew called from profile
        if isEditing {
            // Hide tabBar
            hideTabBar()
            
            // Hide back button
            navigationItem.hidesBackButton = isEditing
            
            // Set a new backButton into leftBarButtonItem
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel"~, style: .plain, target: self, action: #selector(cancelButtonTap))
            
            // Change next button title
            nextButton?.setTitle("Save"~, for: .normal)
            
            // Set a new title for viewController
            self.title = "Brands"~
            
            // Save selected brand into array
            savedBrands = Brands.selected.names
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Reload data after rotation
        brandsCollectionView.reloadData()
    }
    
    // MARK: - Methods
    /// Set top right button to clear or select all
    func configureAllButton() {
        let filteredBrands = Brands.filtered
        allButton.isButtonSelected = filteredBrands.unselected.count < filteredBrands.selected.count
    }
    
    /// Set next button background color and enable / disable it depending on number of brands selected
    /// - Parameter isEnabled: argument used in parent and not used here
    override func configureNextButton(_ isEnabled: Bool = true) {
        let brandsSelected = BrandManager.shared.selectedBrands.count
        let isEnabled = 0 < brandsSelected
        super.configureNextButton(isEnabled)
    }
    
    /// Configure brands collection view layout
    func configureLayout() {
        // Configure the brands collection view
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        brandsCollectionView.register(
            BrandCollectionViewCell.nib,
            forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId
        )
    }
    
    /// Reload  the collection of brand
    func reloadBrands() {
        brands = Brands.withImage.values.sorted()
        
        // Reload data
        brandsCollectionView?.reloadData()
    }
    
    /// Reload  the collection of brand
    func reloadData() {
        // Reload data
        brandsCollectionView?.reloadData()
    }
}
