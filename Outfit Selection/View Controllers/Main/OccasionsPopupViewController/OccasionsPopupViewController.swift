//
//  OccasionsPopupViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionsPopupViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var occasionPickerView: UIPickerView!
    
    // MARK: - Properties
    
    /// Items in the current outfit
    var items = [Item]()
    
    /// The occasions currently selected if any at the calling outfit view controller
    weak var occasionSelected: Occasion?
    
    /// Sorted titles of all occasions
    let occasionTitles = Occasions.titles.sorted()
    
    // MARK: - Inherited Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure occasion picker view
        occasionPickerView.dataSource = self
        occasionPickerView.delegate = self
        
        // Try to use selected occasion if available
        if
            let searchTitle = occasionSelected?.title ?? occasionTitles.first,
            var selectedRow = occasionTitles.firstIndex(of: searchTitle)
        {
            let occasionsCount = occasionTitles.count
            if occasionSelected == nil && Wishlist.outfits.count < occasionsCount {
                // Find the first non-occupied index
                while Wishlist.contains(occasionTitles[selectedRow]) {
                    selectedRow = (selectedRow + 1) % occasionsCount
                }
            }
            occasionPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let occasionIndex = occasionPickerView.selectedRow(inComponent: 0)
        guard 0 <= occasionIndex && occasionIndex < occasionTitles.count else { return }
        Wishlist.add(items, occasion: occasionTitles[occasionIndex])
        
        dismiss(animated: true)
        
        // Select like button at outfit view controller
        let topNavigationController = presentingViewController as? UINavigationController
        let tabBarController = topNavigationController?.findViewController(ofType: UITabBarController.self)
        let navigationController = tabBarController?.selectedViewController as? UINavigationController
        let outfitController = navigationController?.viewControllers.first as? OutfitViewController
        outfitController?.likeButton.isSelected = true
    }
}
