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
    
    /// Default feed sections
    var feedSectionsDefault = [
        PickType.brands,
        PickType.hello,
        PickType.newItems,
        PickType.sale,
    ] + Occasions.selectedIDsUniqueTitle.map { .occasions($0) }
    
    /// Empty sections with information for user
    let feedSectionEmpty = [PickType.brands, PickType.emptyBrands]
    
    /// Items for each of the kinds
    var items: [PickType: Items] = [:]
    
    /// Brands is locking now
    var lockBrands = false
    
    /// The maximum number of items in each section
    let maxItemsInSection = Global.Feed.maxItemsInSection
    
    /// Parent navigation controller if called from another view controller
    var parentNavigationController: UINavigationController?
    
    /// Sections described by picks model
    var picks: Picks = Picks.all
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Types (kinds) for each of the section
    var sections: [PickType] = [] {
        didSet {
            nonEmptySections = sections
        }
    }
    
    /// The set of brand tags previously selected by the user
    var selectedBrands: Set<String> = []
    
    ///Non empty sections after filter
    var nonEmptySections: [PickType] = [] {
        didSet {
            if nonEmptySections == feedSectionEmpty {
                if AppDelegate.canReload && feedCollectionView?.hasUncommittedUpdates == false {
                    feedCollectionView?.reloadData()
                }
            }
        }
    }
    
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
            
            let updatedSections = self.sections.enumerated().compactMap { index, section in
                section == section ? index : nil
            }
            DispatchQueue.main.async {
                self.feedCollectionView?.reloadSections(IndexSet(updatedSections))
            }
        }
    }

    // MARK: - Custom Methods
    /// Append items to the section of given type (section)
    /// - Parameters:
    ///   - items: items to append to the section
    ///   - section: the section type (section) to append the items to
    func addSection(items: Items, to section: PickType) {
        sections.append(section)
        guard !items.isEmpty else {
            getItems(for: section)
            return
        }
        self.items[section] = items
    }
    
    /// Set section into UICollectionView
    /// - Parameters:
    ///   - emptySection: marker for set only brands and an enpty sectiion
    func setSection(with emptySection: Bool = false) {
        
        // Check selected count of brands
        if Brands.selected.count > 0 && !emptySection {
            // Initial sections for feed collection view
            sections = feedSectionsDefault
            // Update all items in sections
            updateItems(sections: sections)
            
        } else {
            // Initial sections for feed collection view
            sections = feedSectionEmpty
        }
    }
    
    /// Register cells, set data source and delegate for a given collection view
    /// - Parameters:
    ///   - collectionView: collection view to setup
    ///   - withBrandsOnTop: if true add brands row on top of collection view
    func setup(_ collectionView: UICollectionView, withBrandsOnTop: Bool) {
        // Register feed cell with feed table view
        BrandCollectionViewCell.register(with: collectionView)
        FeedItemCollectionCell.register(with: collectionView)
        FeedSectionHeaderView.register(with: collectionView)
        
        // Set self as feed table view data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Generate collection view layout
        collectionView.setCollectionViewLayout(configureLayout(withBrandsOnTop: withBrandsOnTop), animated: false)
    }
    
    /// Download items for section
    /// - Parameters:
    ///   - sections: sections for set and download items
    func updateItems(sections: [PickType]) {
        
        // Stop update if sections is not feed sections default
        guard !feedSectionsDefault.filter(sections.contains).isEmpty
                || sections != [PickType.brands, PickType.emptyBrands] else {
            debug("INFO: Unknown sections", sections)
            return
        }
        
        if !Brands.selected.isEmpty {
            // Lock all brands when items is updating
            lockBrands = true
            
            // Dispatch group to wait for all requests to finish
            let group = DispatchGroup()
            
            for section in sections {
                group.enter()
                
                // Get items for section
                self.getItems(for: section, completion: {
                    if self.items[section] == nil || section == .brands || section == .hello  {
                    } else {
                        DispatchQueue.main.async { [self] in
                            // Replace element current section
                            nonEmptySections.replaceElement(section, withElement: section)
                            
                            // Get index with updated element
                            let updatedSections = self.nonEmptySections.enumerated().compactMap { index, kind in
                                section == kind ? index : nil
                            }
                            //debug("INFO: Update:", section, "Items:", items[section]?.count ,"Sections:", sections.count)
                            // Reload sections where was updated items
                            feedCollectionView?.reloadSections(IndexSet(updatedSections))
                        }
                    }
                    group.leave()
                })
            }
            
            // Notification from DispatchQueue group when all section got answer
            group.notify(queue: .main) { [self] in
                debug("INFO: Get items FINISH")
                
                // Get sections with empty items and ignore brands
                let emptySections = sections.filter { items[$0]?.isEmpty ?? true && $0 != .brands || $0 != .hello  }
                
                // Remove all emptySection
                nonEmptySections.removeAll(where: { emptySections.contains($0) } )
                
                // Show choose brands section, if after clear you'll get only brands section
                if nonEmptySections.count <= 1 {
                    self.nonEmptySections = feedSectionEmpty
                }
                
                // Reload data into UICollectionView
                if AppDelegate.canReload && feedCollectionView?.hasUncommittedUpdates == false {
                    feedCollectionView?.reloadData()
                }
                
                // Unlock brands
                lockBrands = false
            }
        }
    }    
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Delete it after test
        let expandedPicks = expand(picks: picks)
        
        for (_, pick) in expandedPicks.enumerated() {
            //debug(index, pick.type, "|", pick.title)
            
            if pick.limit == 0 {
                // TODO: Add to displayed picks
                debug("Skipped:", pick.type, "|",  pick.title)
                continue
            }
            
            getItems(for: pick) { items in
                guard let items = items, !items.isEmpty else {
                    debug("No items:", pick.type, "|",  pick.title)
                    return
                }
                // TODO: Add to displayed picks
                debug("Items count:", items.count, pick.type, "|",  pick.title)
            }
        }
        // TODO: END
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Set navigation item title
        title = "Feed"~
        
        // Set selected brands
        selectedBrands = BrandManager.shared.selectedBrands
        
        // Set section into UICollectionView
        setSection()
        
        // Reload data into UICollectionView
//        if AppDelegate.canReload && feedCollectionView?.hasUncommittedUpdates == false {
//            feedCollectionView?.reloadData()
//        }
        
        // Update items in sections
        //updateItems(sections: sections)
        
        // Add initial values for each section
        //sections.forEach { addSection(items: items[$0] ?? [], to: $0) }
        
        // Make sure like buttons are updated when we come back from see all screen
        feedCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
        
        // Set self as data source and register collection view cells and header
        setup(feedCollectionView, withBrandsOnTop: true)
        
        // Observer for brands, it called when brands selected was changed
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.haveBrandsChanged),
            name: Notification.Name(brandsChanged),
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set margins and paddings for brand cell
        savedBrandCellConstants = (
            BrandCollectionViewCell.horizontalMargin,
            BrandCollectionViewCell.horizontalPadding,
            BrandCollectionViewCell.verticalMargin,
            BrandCollectionViewCell.verticalPadding
        )
        
        BrandCollectionViewCell.horizontalMargin = 0
        BrandCollectionViewCell.horizontalPadding = 20
        BrandCollectionViewCell.verticalMargin = 0
        BrandCollectionViewCell.verticalPadding = 20
        
        //  Reload section with brands
        feedCollectionView.reloadSections(IndexSet([0]))
        
        // Make sure like buttons are updated when we come back from see all screen
        feedCollectionView.visibleCells.forEach {
            ($0 as? FeedItemCollectionCell)?.configureLikeButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore margins and paddings for brand cell
        (
            BrandCollectionViewCell.horizontalMargin,
            BrandCollectionViewCell.horizontalPadding,
            BrandCollectionViewCell.verticalMargin,
            BrandCollectionViewCell.verticalPadding
        ) = savedBrandCellConstants
    }
}
