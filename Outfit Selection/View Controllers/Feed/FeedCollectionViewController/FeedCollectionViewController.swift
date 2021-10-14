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
    let brandedImages = BrandManager.shared.brandedImages.prioritizeSelected
    
    /// Items for each of the kinds
    var items: [FeedKind: [Item]] = [:]
    
    /// The maximum number of items in each section
    let maxItemsInSection = BrandManager.shared.brandedImages.count
    
    /// Parent navigation controller if called from another view controller
    var parentNavigationController: UINavigationController?
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Types (kinds) for each of the section
    var sections: [FeedKind] = []
    
    // MARK: - Custom Methods
    /// Append items to the section of given type (kind)
    /// - Parameters:
    ///   - items: items to append to the section
    ///   - section: the section type (kind) to append the items to
    func addSection(items: [Item], to section: FeedKind) {
        sections.append(section)
        guard !items.isEmpty else {
            getItems(for: section)
            return
        }
        self.items[section] = items
    }
    
    /// Compose layout for feed collection view
    /// - Parameter withBrandsOnTop: if true top row is brands row
    /// - Returns: collection view layout for feed collection view
    private func generateLayout(withBrandsOnTop: Bool) -> UICollectionViewLayout {
        // Define cell spacing
        let spacing: CGFloat = 8
        
        // Define section header size
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(FeedSectionHeaderView.height)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        // Define the item size
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing,
            bottom: 0,
            trailing: spacing
        )
        
        // Define the brand group size
        let brandCount = brandedImages.count
        let brandGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute((BrandCollectionViewCell.width + 2 * spacing) * CGFloat(brandCount)),
            heightDimension: .absolute(BrandCollectionViewCell.height + 2 * spacing)
        )
        let brandGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: brandGroupSize,
            subitem: item,
            count: brandCount
        )
        brandGroup.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        
        // Define brand section size
        let brandSection = NSCollectionLayoutSection(group: brandGroup)
        brandSection.boundarySupplementaryItems = [header]
        brandSection.interGroupSpacing = spacing
        brandSection.orthogonalScrollingBehavior = .continuous
        
        // Define the item group size
        let itemGroupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(FeedItemCollectionCell.width),
            heightDimension: .absolute(FeedItemCollectionCell.height)
        )
        let itemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemGroupSize,
            subitems: [item]
        )
        itemGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        // Define item section size
        let itemSection = NSCollectionLayoutSection(group: itemGroup)
        itemSection.boundarySupplementaryItems = [header]
        itemSection.interGroupSpacing = spacing
        itemSection.orthogonalScrollingBehavior = .continuous
        
        // Define the layout size
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            withBrandsOnTop && sectionIndex == 0 ? brandSection : itemSection
        }
        
        return layout
    }
    
    /// Gets items depending on feed type (kind)
    /// - Parameter kind: feed type (kind)
    func getItems(for kind: FeedKind) {
        // All sections will need to be filtered by brands
        let brandManager = BrandManager.shared
        let brandNames = brandManager.selectedBrandNames
        
        // Categories should be limited for occasions
        let categoryIDs: [Int] = {
            if case let .occasions(name) = kind {
                return Occasion.all[name]?.categoryIDs ?? []
            } else {
                return []
            }
        }()
        let categories = categoryIDs.compactMap { Categories.all[$0] }
        
        // If feed type is sale get items with old prices set
        let sale = kind == .sale
        
        NetworkManager.shared.getItems(
            in: categories,
            filteredBy: brandNames,
            limited: maxItemsInSection,
            sale: sale
        ) { items in
            guard var items = items?.shuffled() else { return }
            
            // Put the last selected brand name first
            if let lastSelectedBrandName = brandManager.lastSelected?.brandName {
                let lastSelectedBrandNames = [lastSelectedBrandName]
                items.sort { $0.branded(lastSelectedBrandNames) || !$1.branded(lastSelectedBrandNames)}
            }
            
            self.items[kind] = items
            
            let updatedSections = self.sections.enumerated().compactMap { index, section in
                section == kind ? index : nil
            }
            DispatchQueue.main.async {
                self.feedCollectionView.reloadSections(IndexSet(updatedSections))
            }
        }
    }
    
    /// Reload data in feed collection view, putting brand name to the beginning if it is not nil
    /// - Parameter brandName: brand name, nil be default
    func reloadDataOnBrandChange() {
        items = [:]
        for section in sections {
            getItems(for: section)
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
        collectionView.setCollectionViewLayout(generateLayout(withBrandsOnTop: withBrandsOnTop), animated: false)
        
        // Clear initial items
        items = [:]
    }
    
    // MARK: - UIViewController Inherited Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case FeedItemViewController.segueIdentifier:
            guard let feedHeader = sender as? FeedSectionHeaderView else {
                debug("Can't cast \(String(describing: sender)) to \(FeedSectionHeaderView.self)")
                return
            }
            
            guard let feedItemViewController = segue.destination as? FeedItemViewController else {
                debug("Can't cast \(segue.destination) to \(FeedItemViewController.self)")
                return
            }
            
            let kind = feedHeader.kind
            feedItemViewController.configure(kind, with: items[kind], named: feedHeader.title)
            
        case ItemViewController.segueIdentifier:
            // Make sure feed item was clicked
            guard let feedItem = sender as? FeedItem else {
                debug("Can't cast \(String(describing: sender)) to \(FeedItem.self)")
                return
            }
            
            // Make sure we segue to item view controller
            guard let itemViewController = segue.destination as? ItemViewController else {
                debug("Can't cast \(segue.destination) to \(ItemViewController.self)")
                return
            }
            
            // Configure item view controller with feed item and its image
            itemViewController.configure(with: feedItem.item, image: feedItem.itemImageView.image)

        default:
            debug("WARNING: unknown segue id \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial sections for feed collection view
        let sections = [
            FeedKind.brands,
            FeedKind.newItems,
            FeedKind.sale,
        ] + Occasion.selectedNames.map { .occasions($0) }
        
        // Set self as data source and register collection view cells and header
        setup(feedCollectionView, withBrandsOnTop: true)
        
        // Add initial values for each section
        sections.forEach { addSection(items: items[$0] ?? [], to: $0) }
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
