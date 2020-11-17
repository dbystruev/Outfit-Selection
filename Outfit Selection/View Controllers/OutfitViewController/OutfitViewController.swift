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
    @IBOutlet var clothesStackView: UIStackView!
    @IBOutlet var pinButtons: [UIButton]!
    @IBOutlet var scrollViews: [PinnableScrollView]!
    
    // MARK: - Properties
    var countButtonItem = UIBarButtonItem(title: "Loading...", style: .done, target: nil, action: nil)
    var diceButtonItem: UIBarButtonItem!
    var gender = Gender.other
    
    // imagePrefixes should correspond to scrollViews
    let imagePrefixes = ["TopLeft", "BottomLeft", "TopRight", "MiddleRight", "BottomRight"]
    
    var selectedAction = UIBarButtonItem.SystemItem.cancel
    var selectedButtonIndex: Int?
    var zoomScale = CGFloat(3)
}
