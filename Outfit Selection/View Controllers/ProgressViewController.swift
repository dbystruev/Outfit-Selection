//
//  ProgressViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Stored Properties
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    /// Switch to tab bar index after the move to tab bar view controller
    var selectedTabBarIndex = 0
    
    // MARK: - Inherited Properties
    /// Hide status bar during progress screen
    override var prefersStatusBarHidden: Bool { true }

    // MARK: - Inherited Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar on top (needed when returning from profile view controller)
        navigationController?.isNavigationBarHidden = true
        
        // Initiate progress with 0
        progressView.progress = 0

        // Instantiate the tab bar controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        guard let tabBarController = controller as? UITabBarController else {
            debug("WARNING: Can't get Tab Bar Controller from the storyboard", mainStoryboard)
            return
        }
        
        // Switch to tab saved in previous version of tab bar controller
        tabBarController.selectedIndex = selectedTabBarIndex
        
        // Get brand names to filter by
        let brandNames = brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
        
        // Load view models with the new images
        let startTime = Date().timeIntervalSince1970
        ItemManager.shared.loadImages(filteredBy: Gender.current, andBy: brandNames) { itemsLoaded, itemsTotal in
            // If not all items loaded — update progress view and continue
            DispatchQueue.main.async {
                self.progressView.progress = itemsTotal == 0 ? 0 : Float(itemsLoaded) / Float(itemsTotal)
            }
            guard itemsLoaded == itemsTotal else { return }
            
            let passedTime = Date().timeIntervalSince1970 - startTime
            
            debug(itemsTotal, "images are loaded from the server into view models in", passedTime.asTime, "seconds")
            
            // Save brand images for future selection change
            BrandManager.shared.brandedImages = self.brandedImages
            
            DispatchQueue.main.async {
                // Unhide top navigation bar
                self.navigationController?.isNavigationBarHidden = false

                // Push to outfit view controller
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
    }
}
