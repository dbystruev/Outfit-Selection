//
//  FeedCollectionViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import IBPCollectionViewCompositionalLayout

/// Controller managing feed collection at feed tab
class FeedCollectionViewController: LoggingViewController {
    // MARK: - Outlets
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    // MARK: - Stored Properties
    /// The name for Notification name
    let brandsChanged = Global.Notification.name.brandsChanged
    
    /// Brand manager
    let brandManager = BrandManager.shared
    
    /// The collection of branded images
    let brandedImages = Brands.prioritizeSelected
    
    /// The current User
    let currentUser = User.current
    
    /// Displayed Picks for data source
    var displayedPicks: Picks = []
    
    /// Items for each of the kinds
    var items: [PickType: Items] = [:]
    
    /// Items for each of the kinds
    var pickItems: [Pick: Items] = [:]
    
    /// Brands is locking now
    var lockBrands = false
    
    /// The maximum number of items in each section
    let maxItemsInSection = Global.Feed.maxItemsInSection
    
    /// Parent navigation controller if called from another view controller
    var parentNavigationController: UINavigationController?
    
    /// Sections described by picks model
    let picks: Picks = Picks.all
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

    /// The set of brand tags previously selected by the user
    var selectedBrands: Set<String> = []
    
    // MARK: - Private Methods
    /// Gets items depending on feed type (section) for  PickType .collections
    /// - Parameters:
    ///   - section: feed type (section)
    ///   - ignoreBrands: should we ignore brands (false by default)
    private func getItems(for type: PickType, ignoreBrands: Bool = false) {
        debug("INFO: Update:", type, "from wislist")
        // All sections will need to be filtered by brands
        let brandNames = brandManager.selectedBrandNames
        
        // Categories should be limited for occasions
        let subcategoryIDs: [Int] = {
            if case let .occasions(id) = type {
                return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? []
            } else {
                return []
            }
        }()
        
        // If feed type is sale get items with old prices set
        let sale = type == .sale
        
        NetworkManager.shared.getItems(
            filteredBy: ignoreBrands ? [] : brandNames,
            limited: maxItemsInSection * 2,
            sale: sale,
            subcategoryIDs: subcategoryIDs
        ) { [weak self] items in
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                return
            }
            
            guard var items = items?.shuffled(), !items.isEmpty else {
                // If no items were returned try again ignoring brands
                if !ignoreBrands {
                    self.getItems(for: type, ignoreBrands: true)
                }
                return
            }
            
            // Put the last selected brand name first
            if let lastSelectedBrandName = self.brandManager.lastSelected?.brandName {
                let lastSelectedBrandNames = [lastSelectedBrandName]
                items.sort { $0.branded(lastSelectedBrandNames) || !$1.branded(lastSelectedBrandNames)}
            }
            
            self.items[type] = items
            
            let updatedSections = items.enumerated().compactMap { index, section in
                section == section ? index : nil
            }
            
            DispatchQueue.main.async {
                if AppDelegate.canReload && self.feedCollectionView?.hasUncommittedUpdates == false {
                    self.feedCollectionView?.reloadSections(IndexSet(updatedSections))
                }
            }
        }
    }
    
    // MARK: - Custom Methods
    /// Append items to the section of given type (section)
    /// - Parameters:
    ///   - items: items to append to the section
    ///   - section: the section type (section) to append the items to
    func addSection(items: Items, to section: PickType) {
        guard !items.isEmpty else {
            getItems(for: section)
            return
        }
        self.items[section] = items
    }
    
    /// Remove items and  section of given type (section)
    /// - Parameters:
    ///   - section: the section type (section) to append the items to
    func removeSection(section: PickType) {
        //sections.removeAll(where: { $0 == section })
        self.items[section] = nil
    }
    
    /// Set section into UICollectionView
    /// - Parameters:
    ///   - emptySection: marker for set only brands and an enpty sectiion
    func setSection(with emptySection: Bool = false) {
            updateItems(picks: picks)
    }
    
    /// Register cells, set data source and delegate for a given collection view
    /// - Parameters:
    ///   - collectionView: collection view to setup
    func setup(_ collectionView: UICollectionView) {
        // Register feed cell with feed table view
        //BrandCollectionViewCell.register(with: collectionView)
        FeedItemCollectionCell.register(with: collectionView)
        FeedSectionHeaderView.register(with: collectionView)
        
        // Set self as feed table view data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Generate collection view layout
        collectionView.setCollectionViewLayout(configureLayout(), animated: false)
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Set navigation item title
        title = "Feed"~
        
        // Set selected brands
        selectedBrands = BrandManager.shared.selectedBrands
        
        // Set section into UICollectionView
        setSection()
        
        // Make sure like buttons are updated when we come back from see all screen
        feedCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
        
        // Set self as data source and register collection view cells and header
        setup(feedCollectionView)
        
        // Observer for brands, it called when brands selected was changed
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.haveBrandsChanged),
            name: Notification.Name(brandsChanged),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure like buttons are updated when we come back from see all screen
        feedCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
