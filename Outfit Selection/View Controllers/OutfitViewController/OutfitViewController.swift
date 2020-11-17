//
//  OutfitViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class OutfitViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var clothesStackView: UIStackView!
    @IBOutlet var pinButtons: [UIButton]!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    
    // MARK: - Stored Properties
    var countButtonItem: UIBarButtonItem!
    var diceButtonItem: UIBarButtonItem!
    var gender = Gender.other
    
    // imagePrefixes should correspond to scrollViews
    let imagePrefixes = ["TopLeft", "BottomLeft", "TopRight", "MiddleRight", "BottomRight"]
    
    var selectedAction = UIBarButtonItem.SystemItem.cancel {
        didSet {
            updateButtons()
        }
    }
    var selectedButtonIndex: Int?
    var zoomScale = CGFloat(3)
    
    // MARK: - Computed Properties
    var price: Double? {
        var amount = 0.0
        for scrollView in scrollViews {
            guard let itemPrice = scrollView.item?.price else { return nil }
            amount += itemPrice
        }
        return amount
    }
}
