//
//  OutfitViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

class OutfitViewController: UIViewController {
    // MARK: - Static Constants
    static let loadingMessage = "Loading..."
    
    // MARK: - Outlets
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var clothesStackView: UIStackView!
    @IBOutlet weak var genderItem: UIBarButtonItem!
    @IBOutlet var pinButtons: [UIButton]!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    
    // MARK: - Stored Properties
    var assetCount = 0
    var brandNames = [String]()
    var countButtonItem: UIBarButtonItem!
    var diceButtonItem: UIBarButtonItem!
    
    /// Gender selected on female male screen
    var gender = Gender.other {
        didSet {
            configureGenderItem()
        }
    }
    
    var selectedAction = UIBarButtonItem.SystemItem.cancel {
        didSet {
            updateButtons()
        }
    }
    var selectedButtonIndex: Int?
    var zoomScale = CGFloat(3)
    
    // MARK: - Computed Properties
    var itemCount: Int {
        scrollViews.reduce(0) { $0 + $1.itemCount }
    }
    
    var price: Double? {
        var amount = 0.0
        for scrollView in scrollViews {
            guard let itemPrice = scrollView.item?.price else { return nil }
            amount += itemPrice
        }
        return amount
    }
    
    /// Update the list of categories from the server
    func updateCategories() {
        NetworkManager.shared.getCategories { categories in
            guard let categories = categories?.sorted(by: { $0.name < $1.name }) else { return }

            for category in categories {
                print("\(category),")
                //print("\(category.id)\t\(category.name)")
            }

            debug("categories.count = \(categories.count)")
        }
    }
}
