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
            // Update the title for go button
            let title = success == true ? "Go" : "Reload"
            
            // Unhide go button when items are loaded
            DispatchQueue.main.async {
                self.goButton.isHidden = false
                self.goButton.setTitle(title, for: .normal)
                self.itemsLoaded = success == true
                
                // Continue only if we loaded items from server successfully
                guard success == true else { return }
                
                // Find out the navigation controller
                guard let navigationController = self.presentingViewController as? UINavigationController else { return }
                
                // Find out the root = outfit view controller
                guard let outfitViewController = navigationController.viewControllers.first as? OutfitViewController else { return }
                
                // Load images into the outfit view controller's sroll views
                outfitViewController.loadImages()
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func goButtonTapped(_ sender: UIButton) {
        guard itemsLoaded else {
            configureItems()
            return
        }
        dismiss(animated: true)
    }
}
