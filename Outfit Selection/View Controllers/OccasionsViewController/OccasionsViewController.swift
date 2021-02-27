//
//  OccasionsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var occasionPickerView: UIPickerView!
    
    // MARK: - Properties
    /// Items in the current outfit
    var items = [Item]()
    
    let occasions = [
        "Daily",
        "Basic",
        "Trendy",
        "Casual",
        "Business",
        "Cocktail",
        "Party",
        "Night",
        "Zoom",
        "Home",
        "Photoshoot",
        "Cute",
        "Chic",
        "Brunch",
        "Eco-friendly",
        "Date",
        "School",
        "College",
        "B-day",
        "Yoga",
        "Street style",
        "Summer",
        "Winter",
        "Barbecue",
        "Boss",
        "Startup",
        "Mommy",
        "Sport",
        "Urban",
        "Burning man",
        "Coachella",
        "Black Tie",
        "Wedding",
        "New Year",
    ].sorted()
    
    // MARK: - Inherited Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure occasion picker view
        occasionPickerView.dataSource = self
        occasionPickerView.delegate = self
        
        // Find the first non-occupied index
        if var shouldSelectRow = occasions.firstIndex(of: "Daily") {
            let occasionsCount = occasions.count
            if Wishlist.outfits.count < occasionsCount {
                while Wishlist.contains(occasions[shouldSelectRow]) {
                    shouldSelectRow = (shouldSelectRow + 1) % occasionsCount
                }
            }
            occasionPickerView.selectRow(shouldSelectRow, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let occasionIndex = occasionPickerView.selectedRow(inComponent: 0)
        guard 0 <= occasionIndex && occasionIndex < occasions.count else { return }
        Wishlist.add(items, occasion: occasions[occasionIndex])
        
        dismiss(animated: true)
        
        // Select like button at outfit view controller
        let topNavigationController = presentingViewController as? UINavigationController
        let tabBarController = topNavigationController?.findViewController(ofType: UITabBarController.self)
        let navigationController = tabBarController?.selectedViewController as? UINavigationController
        let outfitController = navigationController?.viewControllers.first as? OutfitViewController
        outfitController?.likeButton.isSelected = true
    }
}
