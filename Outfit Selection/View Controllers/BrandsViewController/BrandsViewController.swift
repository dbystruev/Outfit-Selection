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
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    @IBOutlet weak var goButton: UIButton!
    
    // MARK: - Properties
    /// Flag which changes to true when all items are loaded from the server
    var itemsLoaded = false
    
    /// The collection of brand images
    let brandImages = BrandManager.shared.brandImages
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
        configureLayout()
    }
    
    // MARK: - Methods
    /// Start loading items from the server
    func configureItems() {
        // Check that there are no loaded items
        itemsLoaded = 0 < Item.all.count
        guard !itemsLoaded else { return }
        
        // Load items if none are found
        goButton.isHidden = true
        ItemManager.shared.loadItems { success in
            // Update the title for go button
            let title = success == true ? "Go" : "Reload"
            
            // Unhide go button when items are loaded
            DispatchQueue.main.async {
                self.goButton.isHidden = false
                self.goButton.setTitle(title, for: .normal)
            }
            
            self.itemsLoaded = success == true
        }
    }
    
    /// Configure brands collection view
    func configureLayout() {
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func goButtonTapped(_ sender: UIButton) {
        guard itemsLoaded else {
            configureItems()
            return
        }
        
        // Find out the navigation controller
        let navigationController = self.presentingViewController as? UINavigationController
        
        // Find out the root = outfit view controller
        let outfitViewController = navigationController?.viewControllers.first as? OutfitViewController
        
        // Save selected brands
        outfitViewController?.brandNames = brandImages.compactMap { $0.isSelected ? $0.brandName : nil }
        
        // Load images into the outfit view controller's sroll views
        outfitViewController?.loadImages()
        
        dismiss(animated: true)
    }
}
