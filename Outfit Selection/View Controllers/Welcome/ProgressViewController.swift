//
//  ProgressViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ProgressViewController: LoggingViewController {
    
    // MARK: - Outlets
    /// Logo on top of progress bar
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.image = UIImage(named: WhiteLabel.logo)
        }
    }
    
    /// Text `picking up the right pieces` above the progress bar
    @IBOutlet weak var progressLabel: UILabel! {
        didSet {
            progressLabel.textColor = WhiteLabel.Color.Text.label
        }
    }
    
    /// The actual progress bar
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.progressTintColor = WhiteLabel.Color.Progress.progressTintColor
            progressView.trackTintColor = WhiteLabel.Color.Progress.trackTintColor
        }
    }
    
    // MARK: - Static Properties
    /// Link to self for others to find
    static weak var `default`: ProgressViewController?
    
    // MARK: - Stored Properties
    /// The collection of brand images
    let brandedImages = BrandManager.shared.brandedImages
    
    /// Switch to tab bar index after the move to tab bar view controller
    var selectedTabBarIndex = 0
    
    // MARK: - Inherited Properties
    /// Hide status bar during progress screen
    override var prefersStatusBarHidden: Bool { true }
    
    // MARK: - Methods
    /// Update progress bar in main dispatch queue
    /// - Parameters:
    ///   - current: number of items processed
    ///   - total: total number of items to process
    ///   - minValue: the minimum value where indicator should start, from 0 to 1, 0 by default
    ///   - maxValue: the maximum value where indicator should end, from 0 to 1, 1 by default
    func updateProgressBar(current: Int, total: Int, minValue: Float = 0, maxValue: Float = 1) {
        // Get value as current fraction of total value
        let value = total == 0 ? 0 : Float(current) / Float(total)
        
        // Update progress view
        DispatchQueue.main.async {
            self.progressView.progress = minValue + (maxValue - minValue) * value
        }
    }

    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure others can find ourselves
        ProgressViewController.default = self
        
        view.backgroundColor = WhiteLabel.Color.Background.light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationManager.navigate(to: .outfit(items: []))
//        // Hide navigation bar on top (needed when returning from profile view controller)
//        navigationController?.isNavigationBarHidden = true
//
//        // Initiate progress with 0
//        progressView.progress = 0
//
//        // Instantiate the tab bar controller
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
//        guard let tabBarController = controller as? UITabBarController else {
//            debug("WARNING: Can't get Tab Bar Controller from the storyboard", mainStoryboard)
//            return
//        }
//
//        // Switch to tab saved in previous version of tab bar controller
//        tabBarController.selectedIndex = selectedTabBarIndex
//
//        // Suggest the wishlist tab with the largest number of items
//        Wishlist.tabSuggested = Wishlist.largestKind
//
//        // Load view models with the new images
//        ItemManager.shared.loadImages(
//            filteredBy: Gender.current,
//            cornerLimit: 1
//        ) { [weak self] itemsLoaded, itemsTotal in
//            // Check for self availability
//            guard let self = self else {
//                debug("ERROR: self is not available")
//                return
//            }
//
//            // If not all items loaded — update progress view and continue
//            self.updateProgressBar(current: itemsLoaded, total: itemsTotal, minValue: 0.5)
//
//            guard itemsLoaded == itemsTotal else { return }
//
//            // Save brand images for future selection change
//            BrandManager.shared.brandedImages = self.brandedImages
//
//            DispatchQueue.main.async {
//                // Unhide top navigation bar
//                self.navigationController?.isNavigationBarHidden = false
//
//                // Push to tab bar view controller
//                self.navigationController?.pushViewController(tabBarController, animated: true)
//            }
//        }
    }
}
