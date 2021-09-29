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
    var brandedImages = BrandManager.shared.brandedImages.selectedFirst
    
    /// Items for each of the kinds
    private var items: [FeedKind: [Item]] = [:]
    
    /// Saved brand cell margins and paddings
    var savedBrandCellConstants: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
    
    /// Types (kinds) for each of the section
    let sections = [
        FeedKind.brands,
        FeedKind.newItems,
        FeedKind.sale,
    ] + Occasion.selectedNames.map { .occasions($0) }
    
    /// The number of items in each section
    let itemsInSection = 42
    
    // MARK: - Custom Methods
    /// Compose layout for feed collection view
    /// - Returns: collection view layout for feed collection view
    private func generateLayout() -> UICollectionViewLayout {
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
            widthDimension: .absolute(FeedItemCollectionCell.width * CGFloat(itemsInSection)),
            heightDimension: .absolute(FeedItemCollectionCell.height)
        )
        let itemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemGroupSize,
            subitem: item,
            count: itemsInSection
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
            sectionIndex == 0 ? brandSection : itemSection
        }
        
        return layout
    }
    
    /// Select items depending on feed type (kind)
    /// - Parameter kind: feed type (kind)
    /// - Returns: the items selected for the given type (kind)
    func items(for kind: FeedKind) -> [Item] {
        // Check that the items for the given kind are already present
        if let items = items[kind] { return items }
        
        // Compose the list of items for section
        var items: [Item] = []
        for _ in 0 ..< itemsInSection {
            guard let item = Item.all.randomElement()?.value else { return items }
            items.append(item)
        }
        self.items[kind] = items
        return items
    }
    
    /// Reload data in feed collection view, putting brand name to the beginning if it is not nil
    /// - Parameter brandName: brand name, nil be default
    func reloadDataOnBrandChange() {
        brandedImages = BrandManager.shared.brandedImages.selectedFirst
        NetworkManager.shared.reloadItems(for: Gender.current) { success in
            guard success == true else { return }
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
        }
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
                debug("Can't case \(segue.destination) to \(FeedItemViewController.self)")
                return
            }
            
            let kind = feedHeader.kind
            feedItemViewController.items = items(for: kind)
            feedItemViewController.kind = kind
            feedItemViewController.name = feedHeader.title
            
        case ItemViewController.segueIdentifier:
            guard let feedItem = sender as? FeedItem else {
                debug("Can't cast \(String(describing: sender)) to \(FeedItem.self)")
                return
            }
            
            guard let itemViewController = segue.destination as? ItemViewController else {
                debug("Can't cast \(segue.destination) to \(ItemViewController.self)")
                return
            }
            
            itemViewController.image = feedItem.itemImageView.image
            itemViewController.item = feedItem.item
            
        default:
            debug("WARNING: unknown segue id \(String(describing: segue.identifier))")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as data source for the feed collection view
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        
        // Register collection view cells and header
        feedCollectionView.register(BrandCollectionViewCell.nib, forCellWithReuseIdentifier: BrandCollectionViewCell.reuseId)
        feedCollectionView.register(
            FeedItemCollectionCell.self,
            forCellWithReuseIdentifier: FeedItemCollectionCell.reuseId
        )
        feedCollectionView.register(
            FeedSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FeedSectionHeaderView.reuseId
        )
        
        // Use the layout generated by custom method
        feedCollectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        debug("DEBUG: \(sections.count) item groups: \(sections)")
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
