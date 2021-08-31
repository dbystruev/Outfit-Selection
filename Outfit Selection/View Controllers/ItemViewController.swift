//
//  ItemViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import SafariServices

class ItemViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    // MARK: - Properties
    var image: UIImage?
    var item: Item?
    var itemIndex = -1

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        item = 0 <= itemIndex && itemIndex < Item.all.count ? Item.all[itemIndex] : nil
        
        updateUI()
    }
    
    func updateUI() {
        if let name = item?.name, let firstLetter = name.first?.uppercased() {
            nameLabel.text = firstLetter + name.dropFirst()
        } else {
            nameLabel.text = nil
        }
        priceButton.isHidden = item == nil
        title = item?.price?.asPrice
    }
    
    // Actions
    @IBAction func priceButtonTapped(_ sender: UIButton) {
        guard let url = item?.url else { return }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        
        let controller = SFSafariViewController(url: url, configuration: config)
        present(controller, animated: true)
        
        debug(url)
    }
}
