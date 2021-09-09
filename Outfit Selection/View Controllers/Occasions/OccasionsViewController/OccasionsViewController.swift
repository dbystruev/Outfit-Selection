//
//  OccasionsViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var occasionsTableView: UITableView!
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        occasionsTableView.dataSource = self
        occasionsTableView.delegate = self
        occasionsTableView.separatorStyle = .none
    }
}
