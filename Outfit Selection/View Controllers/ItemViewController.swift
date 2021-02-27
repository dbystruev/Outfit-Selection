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
    @IBOutlet weak var addToWishlistButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var vendorLabel: UILabel!
    
    // MARK: - Properties
    var image: UIImage?
    var item: Item?
    var itemIndex = -1

    // MARK: - Custom Methods
    /// Fill labels with item data
    func updateUI() {
        addToWishlistButton.isSelected = Wishlist.contains(item) ?? false
        nameLabel.text = item?.nameWithoutVendor
        orderButton.isHidden = item == nil
        title = item?.price?.asPrice
        vendorLabel.text = item?.vendor?.uppercased()
    }
    
    /// Set last emotion in outfit view controller to item
    func setLastEmotionToItem() {
        // Set most recent like/dislike to item
        let outfitViewController = navigationController?.findViewController(ofType: OutfitViewController.self)
        outfitViewController?.wasLastEmotionAboutItem = true
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        item = 0 <= itemIndex && itemIndex < Item.all.count ? Item.all[itemIndex] : nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: - Actions
    @IBAction func addToWishlistButtonTapped(_ sender: UIButton) {
        if Wishlist.contains(item) == true {
            dislikeButtonTapped(sender)
        } else {
            sender.isSelected = true
            setLastEmotionToItem()
            Wishlist.add(item)
        }
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        addToWishlistButton.isSelected = false
        setLastEmotionToItem()
        Wishlist.remove(item)
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        guard let url = item?.url else { return }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = false
        
        let controller = SFSafariViewController(url: url, configuration: config)
        present(controller, animated: true)
        
        debug(url)
    }
}
