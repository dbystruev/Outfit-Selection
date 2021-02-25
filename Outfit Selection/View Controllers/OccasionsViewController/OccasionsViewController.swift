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
        debug()
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure occasion picker view
        occasionPickerView.dataSource = self
        occasionPickerView.delegate = self
        if let dailyIndex = occasions.firstIndex(of: "Daily") {
            occasionPickerView.selectRow(dailyIndex, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        debug()
        dismiss(animated: true)
    }
}
