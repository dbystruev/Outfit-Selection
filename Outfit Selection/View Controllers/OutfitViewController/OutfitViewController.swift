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
    @IBOutlet var clothesStackView: UIStackView!
    @IBOutlet var scrollViews: [UIScrollView]!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: - Properties
    let bundleFolders = ["Top Left", "Bottom Left", "Top Right", "Middle Right", "Bottom Right"]
    
    var selectedAction = UIBarButtonItem.SystemItem.cancel
    var selectedButtonIndex: Int?
    var zoomScale = CGFloat(3)
}
