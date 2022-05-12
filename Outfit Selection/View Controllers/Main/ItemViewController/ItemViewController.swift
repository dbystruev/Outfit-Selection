//
//  ItemViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

class ItemViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var addToCollectionButton: UIButton! {
        didSet {
            addShadow(for: addToCollectionButton, cornerRadius: 20)
        }
    }
    
    @IBOutlet weak var addToWishlistButton: WishlistButton! {
        didSet {
            addToWishlistButton.imageView?.contentMode = .scaleAspectFit
            addShadow(for: addToWishlistButton, cornerRadius: 20)
        }
    }
    
    @IBOutlet weak var dislikeButton: WishlistButton! {
        didSet {
            dislikeButton.imageView?.contentMode = .scaleAspectFit
            addShadow(for: dislikeButton.superview!, cornerRadius: 20)
            
            // Need to know which button to change when dislike button is tapped
            dislikeButton.addToWishlistButton = addToWishlistButton
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.imageView?.contentMode = .scaleAspectFill
            addShadow(for: shareButton, cornerRadius: 20)
        }
    }
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet var orderButtonHorizontalConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var nameLabels: [UILabel]!
    
    @IBOutlet weak var orderButton: UIButton! {
        didSet {
            orderButton.backgroundColor = Globals.Color.Button.enabled
            orderButton.setTitleColor(Globals.Color.Button.titleColor, for: .normal)
        }
    }
    /// The  table view with items list
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet  var priceLabels: [UILabel]!
    @IBOutlet weak var rightLabelsStackView: UIStackView!
    
    /// Search bar for the item
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableStackView: UIStackView!
    
    @IBOutlet weak var topLabelsStackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var trailingStackView: UIStackView!
    @IBOutlet var vendorLabels: [UILabel]!
    
    // MARK: - Properties
    /// Time of last click in search bar
    var lastClick: Date?
    
    /// The limit of count items after request
    let limited = 25
    
    /// Maximum width of order button: design screen width (375) - left (16) and right (16) margins
    let orderButtonMaxWidth: CGFloat = 343
    
    /// Time delay before closing search keybaord
    static let searchKeystrokeDelay: TimeInterval = 0.25
    
    // MARK: - Stored Properties
    
    // Set new backButton into leftBarButtonItem
    let backBarButtonItem = UIBarButtonItem()
    
    // Set new cancel into leftBarButtonItem
    let cancelButton = UIBarButtonItem()
    
    /// First item image
    private var image: UIImage?
    
    /// Item  to show
    private(set) var item: Item? 
    
    /// The firts Item when controller  start
    var firstItem: Item?
    
    /// The marker for edit mode
    var isEditingEnabled = false
    
    /// Items for searchBar
    var searchItems: Items?
    
    // Save entered search text
    var searchText: String?
    
    /// Save searchItems
    var searchItemsSave: Items?
    
    /// Item url to present at Intermediary view controller
    var url: URL?
    
    // MARK: - Custom Methods
    /// Add shadow to the layer with given corner radius
    /// - Parameters:
    ///   - view: view to add shadow to
    ///   - cornerRadius: view corner radius to use
    ///   - shadowRadius: shadow radius to use
    ///   - inset: inset for shadow path, 0 be default
    func addShadow(for view: UIView, cornerRadius: CGFloat, inset: CGFloat = 0) {
        let grade: CGFloat = 151 / 255
        let layer = view.layer
        layer.cornerRadius = cornerRadius
        layer.shadowColor = UIColor(red: grade, green: grade, blue: grade, alpha: 0.2).cgColor
        layer.shadowOpacity = 1
        layer.shadowPath = UIBezierPath(roundedRect: view.bounds.insetBy(dx: inset, dy: inset), cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = 10
    }
    
    
    /// Configure item view controller with given item and first image
    /// - Parameters:
    ///   - item: an item to configure the view controller with
    func configure(with item: Item?) {
        self.item = item
        self.imageView?.configure(with: item?.pictures.first)
    }
    
    /// Configure item view controller with given item and its image
    /// - Parameters:
    ///   - item: an item to configure the view controller with
    ///   - image: an image to configure the view controller with
    ///   - isEditingEnabled: the marker for edit mode
    func configure(with item: Item?, image: UIImage?, isEditingEnabled: Bool = false) {
        self.item = item
        self.image = image
        self.isEditingEnabled = isEditingEnabled
        
        if image == nil {
            guard let imageURL = item?.pictures.first else {
                debug("ERROR: Item", item, "has no pictures")
                return
            }
            // Get images from
            NetworkManager.shared.getImage(imageURL) { image in
                self.image = image
                DispatchQueue.main.async {
                    self.loadImages()
                }
            }
        }
    }
    
    /// Load item pictures to image view and image stack view
    func loadImages() {
        // Load the first image
        imageView?.image = image
        debug(imageView?.image)
        // Get the URLs for the second and all other images
        guard let imageURLs = item?.pictures, 1 < imageURLs.count else { return }
        
        // Load images into stack view
        for imageURL in imageURLs.dropFirst() {
            NetworkManager.shared.getImage(imageURL) { [weak self] image in
                // Check for self availability
                guard let self = self else {
                    debug("ERROR: self is not available")
                    return
                }
                
                guard let image = image else { return }
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    self.imageStackView.addArrangedSubview(imageView)
                }
            }
        }
    }
    
    /// Update UI properties when screen rotates
    /// - Parameter isHorizontal: true in landscape mode, false in portrait
    func updateLayout(isHorizontal: Bool) {
        rightLabelsStackView.isHidden = !isHorizontal
        topLabelsStackView.isHidden = isHorizontal
        parentStackView.axis = isHorizontal ? .horizontal : .vertical
        parentStackView.distribution = isHorizontal ? .fillEqually : .fill
        
        // Update order button constraints
        updateOrderButtonConstraints()
    }
    
    /// Makes sure the button width does not exceed ItemViewController.orderButtonMaxWidth
    func updateOrderButtonConstraints() {
        // Calculate order button width if its constraints zeroed
        let orderButtonWidth = trailingStackView.frame.width
        
        // Calculate order button constraints so its width does not exceed orderButtonMaxWidth
        let constant =  orderButtonWidth < orderButtonMaxWidth ? 0 : (orderButtonWidth - orderButtonMaxWidth) / 2
        
        // Assign order button constraints
        orderButtonHorizontalConstraints.forEach { $0.constant = constant }
    }
    
    /// Fill labels with item data
    func updateUI() {
        guard let item = item else { return }
        addToWishlistButton?.configure(for: item)
        let nameWithoutVendor = item.nameWithoutVendor
        nameLabels.forEach { $0.text = nameWithoutVendor }
        //title = item.price.asPrice
        
        // Set price to label
        priceLabels.forEach  { $0.text = item.price.asPrice }
        
        let vendorUppercased = item.vendorName.uppercased()
        vendorLabels.forEach { $0.text = vendorUppercased }
    }
    
    // MARK: - Inherited Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addToWishlistButton.isEnabled = !isEditing
        
        // Set custom title for Edit button
        navigationItem.rightBarButtonItem?.title = isEditing ? "Save"~ : "Edit"~
        
        // Set new title for Button
        orderButton.setTitle( isEditing ? "Save"~ : "Shop now"~, for: .normal)
        searchBar.isHidden = !isEditing
        shareButton.isEnabled = !isEditing
        
        // Set title
        //title = isEditing ? "Edit"~ : "" //item?.price.asPrice
        
        // Hide or show backButton
        navigationItem.hidesBackButton = isEditing
        
        if isEditing {
            // Configure Back button leftBarButtonItem
            backBarButtonItem.title = "Back"~
            backBarButtonItem.target = self
            backBarButtonItem.action = #selector(backButtonTap)
            backBarButtonItem.isEnabled = false
            
            // Configure cancel button leftBarButtonItem
            cancelButton.title = "Cancel"~
            cancelButton.target = self
            cancelButton.action = #selector(cancelButtonTap)
            
            // Set bar button items into left bar
            navigationItem.leftBarButtonItems = [backBarButtonItem, cancelButton]
            
        } else {
            // Set empty barButtonItem
            navigationItem.leftBarButtonItems = []
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the items table view
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.placeholder = "Enter name please"~
        
        loadImages()
        
        // Configyre editButtonItem
        if isEditingEnabled {
            navigationItem.rightBarButtonItem = editButtonItem
            navigationItem.rightBarButtonItem?.action = #selector(editButtonItemTap)
        } else {
            // Clear rightBarButtonItem
            navigationItem.rightBarButtonItem = nil
            //shareButton.isHidden = true
        }
        
        // Hide Search bar
        searchBar.isHidden = true
        firstItem = item
        
        // Tap gesture recognizer for UIImageView
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(imageViewTap)
        imageView.isUserInteractionEnabled = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show Tabbar
        showTabBar()
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let frame = view.frame
        updateLayout(isHorizontal: frame.height < frame.width)
    }
}
