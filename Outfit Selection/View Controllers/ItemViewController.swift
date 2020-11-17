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
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    var image: UIImage?
    var item: Item?
    var itemIndex = 0

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        debug(itemIndex, Item.all.count)
        
        item = itemIndex < Item.all.count ? Item.all[itemIndex] : nil
        
        updateUI()
    }
    
    func updateUI() {
        nameLabel.text = item?.name
        if let price = item?.price {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.numberStyle = .currency
            let amount = formatter.string(from: NSNumber(value: price))
            title = amount
        }
    }
}
