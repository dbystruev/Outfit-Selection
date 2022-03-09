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
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Static Constants
    /// Time delay before closing search keybaord
    static let searchKeystrokeDelay: TimeInterval = 0.25
    
    // MARK: - Stored Properties
    /// The collection of brand images
    private(set) var brands: [Brand] = Brands.filtered.values.sorted()
    
    /// The string to filter brand search results
    var filterString = "" {
        didSet {
            Brands.filterString = filterString
            brands = Brands.filtered.values.sorted()
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
}
