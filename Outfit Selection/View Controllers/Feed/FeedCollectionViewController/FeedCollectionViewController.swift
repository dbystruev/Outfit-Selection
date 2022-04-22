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
    /// The collection of branded images
    let brandedImages = Brands.prioritizeSelected
    
    /// Items for each of the kinds
    var items: [FeedKind: Items] = [:] {
        didSet {
            debug()
        }
    }
    
    /// The maximum number of items in each section
    let maxItemsInSection = Globals.Feed.maxItemsInSection
    
    /// Parent navigation controller if called from another view controller
    var parentNavigationController: UINavigationController?
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Types (kinds) for each of the section
    var sections: [FeedKind] = [] {
        didSet {
            
            // Set self as data source and register collection view cells and header
            setup(feedCollectionView, withBrandsOnTop: true)
            
            // Add initial values for each section
            //sections.forEach { addSection(items: items[$0] ?? [], to: $0) }
            
            if !Brands.selected.isEmpty {
                for section in nonEmptySections {
                    getItems(for: section)
                }
            }
        }
    }
    
    var nonEmptySections: [FeedKind] {
        // Filter not working because items all time will be nil
        return sections.filter { true || [.brands, .emptyBrands].contains($0) || items[$0]?.isEmpty != true }
    }
    
    // MARK: - Custom Methods
    /// Append items to the section of given type (kind)
    /// - Parameters:
    ///   - items: items to append to the section
    ///   - section: the section type (kind) to append the items to
    func addSection(items: Items, to section: FeedKind) {
        if !items.isEmpty {
            
            debug("INFO: No items in section", section.title )
            self.items[section] = nil
            
            // TODO: Remove self section
            //sections.removeAll(where: { $0 == section })
            
            //getItems(for: section)
        } else {
            sections.append(section)
            self.items[section] = items
        }
    }
    
    /// Gets items depending on feed type (kind)
    /// - Parameters:
    ///   - kind: feed type (kind)
    ///   - ignoreBrands: should we ignore brands (false by default)
    func getItems(for kind: FeedKind, ignoreBrands: Bool = false) {
        // Stop loading if it brands or noBrands section
        guard kind != .brands || kind != .emptyBrands else {
            debug("INFO: Stop loading items for", kind.title)
            return
        }
        
        // All sections will need to be filtered by brands
        let brandManager = BrandManager.shared
        let brandNames = brandManager.selectedBrandNames
        
        // Categories should be limited for occasions
        let subcategoryIDs: [Int] = {
            if case let .occasions(id) = kind {
                return Occasions.byID[id]?.flatSubcategoryIDs.compactMap { $0 } ?? []
            } else {
                return []
            }
        }()
        
        // If feed type is sale get items with old prices set
        let sale = kind == .sale
        NetworkManager.shared.getItems(
            subcategoryIDs: subcategoryIDs,
            filteredBy: ignoreBrands ? [] : brandNames,
            limited: self.maxItemsInSection * 2,
            sale: sale
        ) { [weak self] items in
            // Check for self availability
            guard let self = self else {
                debug("ERROR: self is not available")
                return
            }
            
            // Check items
            guard var items = items?.shuffled(), !items.isEmpty else {
                // If no items were returned try again ignoring brands
                if !ignoreBrands {
                    debug("INFO: No items in", kind.title)
                    //guard let index = self.sections.firstIndex(of: kind) else { return }
                    
                    DispatchQueue.main.async {
                        //self.sections.remove(at: index)
                    }
                }
                return
            }
            
            // Put the last selected brand name first
            if let lastSelectedBrandName = brandManager.lastSelected?.brandName {
                let lastSelectedBrandNames = [lastSelectedBrandName]
                items.sort { $0.branded(lastSelectedBrandNames) || !$1.branded(lastSelectedBrandNames)}
            }
            
            self.items[kind] = items
            
            let updatedSections = self.nonEmptySections.enumerated().compactMap { index, section in
                section == kind ? index : nil
            }
            
            DispatchQueue.main.async {
                self.feedCollectionView?.reloadSections(IndexSet(updatedSections))
            }
        }
    }
    
    /// Reload data in feed collection view, putting brand name to the beginning if it is not nil
    /// - Parameter brandName: brand name, nil be default
    func reloadDataOnBrandChange() {
        
        if Brands.selected.count > 0 {
            // Initial sections for feed collection view
            sections = [
                FeedKind.brands,
                FeedKind.newItems,
                FeedKind.sale,
            ] + Occasions.selectedIDsUniqueTitle.map { .occasions($0) }
            
            //  Reload section with brands
            feedCollectionView.reloadSections(IndexSet([0,1]))
            
        } else {
            
            // Initial sections for feed collection view
            sections = [FeedKind.brands, FeedKind.emptyBrands]
            for (index, _) in sections.enumerated() {
                // Reload section
                feedCollectionView.reloadSections(IndexSet([index]))
            }
            
            debug(sections.count, "INFO: Nothing selected from brands")
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
        
        // Clear initial items
        items = [:]
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure navigation controller's bar font
        navigationController?.configureFont()
        
        // Set navigation item title
        title = "Feed"~
        
        reloadDataOnBrandChange()
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
