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
    @IBOutlet weak var brandsCollectionView: BrandsCollectionView!
    
    // MARK: - Static Constants
    /// Time delay before closing search keybaord
    static let searchKeystrokeDelay: TimeInterval = 1
    
    // MARK: - Stored Properties
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
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
        brandedImages.filter = ""
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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        brandsCollectionView.reloadData()
    }
    
    // MARK: - Methods
    /// Set top right button to clear or select all
    func configureAllButton() {
        allButton.isButtonSelected = brandedImages.unselected.count < brandedImages.selected.count
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
