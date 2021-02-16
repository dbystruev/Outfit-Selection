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
        didSet {
            // Don't clear items if gender value did not change
            guard gender != oldValue else { return }
            
            // Clear all loaded items
            Item.removeAll()
        }
    }
    
    /// Flag which changes to true when all items are loaded from the server
    var allItemsLoaded = false
    
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    // MARK: - Computed Properties
    /// Number of columns in the brands collection view
    var columns: CGFloat { CGFloat(BrandCell.cellsPerRow) }
    
    /// The size of single side of the cell in the brands collection view
    var cellSide: CGFloat { floor((brandsCollectionView.bounds.size.width - 10 * columns - 32) / columns) }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
        configureLayout()
        configureContent(sized: view.frame.size)
    }
    
    override func viewWillLayoutSubviews() {
        debug()
        super.viewWillLayoutSubviews()
        brandsCollectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        debug()
        super.viewWillTransition(to: size, with: coordinator)
        configureContent(sized: size)
    }
    
    // MARK: - Methods
    /// Configure the number of cells per row depending on view size
    /// - Parameter size: view size for which we need to configure brand cells per row
    func configureContent(sized size: CGSize) {
        BrandCell.cellsPerRow = size.height < size.width ? 6 : 3
    }
    
    /// Start loading items from the server
    func configureItems() {
        // Check that there are no loaded items
        allItemsLoaded = 0 < Item.all.count
        guard !allItemsLoaded else { return }
        
        // Load items if none are found
        getOutfitButton.isHidden = true
        ItemManager.shared.loadItems(filteredBy: gender) { success in
            // Update the title for go button
            self.allItemsLoaded = success == true
            let title = self.allItemsLoaded ? "Get Outfit" : "Reload"
            
            // Unhide go button when items are loaded
            DispatchQueue.main.async {
                self.getOutfitButton.isHidden = false
                self.getOutfitButton.setTitle(title, for: .normal)
            }
        }
    }
    
    /// Configure brands collection view
    func configureLayout() {
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
    }
}
