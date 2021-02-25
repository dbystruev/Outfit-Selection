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
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    
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
        orderButton.isHidden = item == nil
        wishlistButton.isSelected = Wishlist.contains(item) ?? false
        title = item?.price?.asPrice
    }
    
    // Actions
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        guard let url = item?.url else { return }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        
        let controller = SFSafariViewController(url: url, configuration: config)
        present(controller, animated: true)
        
        debug(url)
    }
    
    @IBAction func wishlistButtonTapped(_ sender: UIButton) {
        if Wishlist.contains(item) == true {
            Wishlist.remove(item)
            sender.isSelected = false
        } else {
            Wishlist.add(item)
            sender.isSelected = true
        }
    }
}
