//
//  ItemViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var image: UIImage?
    var itemIndex = 0

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        debug(itemIndex)
        imageView.image = image
    }
}
