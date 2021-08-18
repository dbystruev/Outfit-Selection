//
//  FeedViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check file loading from bundle
        guard let path = Bundle.main.path(forResource: "female", ofType: "json") else { return }
        guard let contents = try? String(contentsOfFile: path) else { return }
        debug("contents.count =", contents.count);
    }
    
}
