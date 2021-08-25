//
//  FeedItemCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedItemCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var seeAllButton: DelegatedButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Static Constants
    static let designFactor: CGFloat = 1.25
    
    /// Default item sizes
    static let itemHeight: CGFloat = 206 * designFactor
    static let itemWidth: CGFloat = 120 * designFactor
    
    /// Default cell's height
    static let height: CGFloat = 282 * designFactor
    
    // MARK: - Class Properties
    class var identifier: String { nib }
    class var nib: String { String(describing: Self.self) }
    
    // MARK: - Class Methods
    /// Registers the cell with the table view
    /// - Parameter tableView: the table view to register with
    /// - Returns: (optional) returns cell identifier, also available as MessageListCell.identifier
    @discardableResult class func register(with tableView: UITableView?) -> String {
        let aNib = UINib(nibName: nib, bundle: nil)
        tableView?.register(aNib, forCellReuseIdentifier: identifier)
        return identifier
    }
    
    // MARK: - Stored Properties
    /// Delegate to call when see all button is tapped
    var delegate: ButtonDelegate?
    
    /// Items to display in the item stack view
    var items: [Item] = []
    
    /// Kind of this cell
    var kind: Kind = .sale
    
    /// There are 3 kinds of feed cell so far
    enum Kind: CaseIterable {
        case brands
        case newItems
        case sale
        
        var title: String {
            switch self {
            case .brands:
                return "Favorite brands"
            case .newItems:
                return "New items for you"
            case .sale:
                return "Sales"
            }
        }
    }
    
    // MARK: - Computed Properties
    var title: String { kind.title }
    
    // MARK: - Inherited Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    /// Make sure to remove item stack view subviews
    override func prepareForReuse() {
        super.prepareForReuse()
        itemStackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Custom Methods
    /// Called after items has been assigned
    func configureItems() {
        // Remove xib subview to allow space for new items
        guard 0 < items.count else { return }
        itemStackView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add new items to the items stack view
        for item in items {
            // Insert feed item subviews into item stack view
            guard let feedItem = FeedItem.instanceFromNib() else {
                debug("Can't instantiate FeedItem from Nib")
                return
            }
            itemStackView.addArrangedSubview(feedItem)
            feedItem.configureContent(with: item, showSale: kind == .sale)
        }
        
        // Configure constraints for the first item — the rest will follow suit
        guard let item = itemStackView.arrangedSubviews.first else { return }
        let heightConstraint = NSLayoutConstraint(
            item: item, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: FeedItemCell.itemHeight
        )
        let widthConstraint = NSLayoutConstraint(
            item: item, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: FeedItemCell.itemWidth
        )
        NSLayoutConstraint.activate([heightConstraint, widthConstraint])
    }
    
    /// Called when we know for sure what items we want to display
    /// - Parameters:
    ///   - kind: cell's type
    ///   - items: the items which needs to be displayed in the item stack view
    func configureContent(for kind: Kind, items: [Item]) {
        // Configure variables
        self.kind = kind
        let filteredItems = items.filter({ $0.price != nil && $0.oldPrice != nil })
        let numberOfItems = min(Int.random(in: 20...30), filteredItems.count)
        self.items = Array(filteredItems.shuffled()[...numberOfItems])
        
        // Configure outlets
        titleLabel.text = title
        configureItems()
    }
    
    /// Called from awakeFromNib() in the beggining, when we don't know yet what to display
    func configureLayout() {
        // No selection style be default
        selectionStyle = .none
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(sender)
    }
}
