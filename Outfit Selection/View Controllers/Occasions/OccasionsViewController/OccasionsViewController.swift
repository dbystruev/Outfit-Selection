//
//  OccasionsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionsViewController: LoggingViewController {
    
    // MARK: - Outlets
    /// Go button at the bottom of the screen
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.backgroundColor = Globals.Color.Button.enabled
        }
    }
    
    /// The main table view with occasion list
    @IBOutlet weak var occasionsTableView: UITableView!
    
    // MARK: - Stored Properties
    var occasions: [Occasion] = Occasion.all.keys.sorted().compactMap { Occasion.all[$0] }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        occasionsTableView.dataSource = self
        occasionsTableView.delegate = self
        occasionsTableView.separatorStyle = .none
    }
}
