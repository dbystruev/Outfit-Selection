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
    
    // MARK: - Inhertited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup profile collection view
        profileCollectionView.dataSource = self
    }
}
