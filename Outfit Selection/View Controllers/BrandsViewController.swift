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
    @IBOutlet weak var brandsStackView: UIStackView!
    @IBOutlet weak var goButton: UIButton!
    
    // MARK: - Properties
    var itemsLoaded = false
    
    // MARK: - Inherited Methods
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier == "OutfitViewController" else { return false }
        guard itemsLoaded else {
            configureItems()
            return false
        }
        return itemsLoaded
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
        configureContent()
    }
    
    // MARK: - Methods
    /// Fill brands stack view with brand images
    func configureContent() {
        for image in BrandManager.shared.brandImages {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            brandsStackView.addArrangedSubview(imageView)
        }
    }
    
    /// Start loading items from the server
    func configureItems() {
        goButton.isHidden = true
        ItemManager.shared.loadItems { success in
            let title = success == true ? "Go" : "Reload"
            
            // Unhide go button when items are loaded
            DispatchQueue.main.async {
                self.goButton.isHidden = false
                self.goButton.setTitle(title, for: .normal)
                self.itemsLoaded = success == true
            }
        }
    }
}
