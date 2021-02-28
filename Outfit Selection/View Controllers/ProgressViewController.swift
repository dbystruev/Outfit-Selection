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
    
    // MARK: - Properties
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar on top
        navigationController?.navigationBar.isHidden = true
        
        // Initiate progress with 0
        progressView.progress = 0

        // Instantiate the Outfit View Controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        guard let tabBarController = controller as? UITabBarController else {
            debug("WARNING: Can't get Tab Bar Controller from the storyboard", mainStoryboard)
            return
        }
        guard let navigationController = tabBarController.viewControllers?.first as? UINavigationController else {
            debug("WARNING: Can't get Naviation Controller from the storyboard")
            return
        }
        guard let outfitViewController = navigationController.viewControllers.first as? OutfitViewController else {
            debug("WARNING: Can't get Outfit View Controller from the storyboard", mainStoryboard)
            return
        }
        
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
            
            // Save selected brands (do not use brand names as the user could have changed the selection while waiting)
            outfitViewController.brandNames = self.brandedImages.compactMap { $0.isSelected ? $0.brandName : nil }
            
            // Save brand images for future selection change
            BrandManager.shared.brandedImages = self.brandedImages
            
            DispatchQueue.main.async {
                // Unhide top navigation bar
                self.navigationController?.navigationBar.isHidden = false

                // Push to outfit view controller
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }

    }
}
