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
    @IBOutlet weak var addToWishlistButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var vendorLabel: UILabel!
    
    // MARK: - Properties
    var image: UIImage?
    var item: Item?
    var itemIndex = -1
    
    /// Item url to present at Intermediary view controller
    var url: URL?

    // MARK: - Custom Methods
    /// Fill labels with item data
    func updateUI() {
        addToWishlistButton.isSelected = Wishlist.contains(item) ?? false
        nameLabel.text = item?.nameWithoutVendor
        orderButton.isHidden = item == nil
        title = item?.price?.asPrice
        vendorLabel.text = item?.vendor?.uppercased()
    }
    
    /// Set last emotion in wish list to items
    func setLastEmotionToItems() {
        // Set most recent like/dislike to item
        Wishlist.itemsTabSuggested = true
    }
    
    // MARK: - Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "intermediaryViewControllerSegue" else { return }
        let intermediaryViewController = segue.destination as? IntermediaryViewController
        intermediaryViewController?.url = url
    }
    
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
            setLastEmotionToItems()
            Wishlist.add(item)
        }
    }
    
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        addToWishlistButton.isSelected = false
        setLastEmotionToItems()
        Wishlist.remove(item)
    }
    
    @IBAction func orderButtonTapped(_ sender: UIButton) {
        guard let url = item?.url else { return }
        self.url = url
        performSegue(withIdentifier: "intermediaryViewControllerSegue", sender: sender)
    }
}
