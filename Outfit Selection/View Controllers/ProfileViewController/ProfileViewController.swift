//
//  ProfileViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    // MARK: - Stored Properties
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    /// Brands view controller to use as profile collection view data source
    var brandsViewController: BrandsViewController?
    
    // MARK: - Inhertited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find brands view controller
        brandsViewController = navigationController?.findViewController(ofType: BrandsViewController.self)
        
        // Setup profile collection view
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
    }
}