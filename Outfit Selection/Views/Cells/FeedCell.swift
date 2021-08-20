//
//  FeedCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var seeAllButton: DelegatedButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Class Properties
    class var identifier: String { nib }
    class var nib: String { String(describing: Self.self) }
    
    // MARK: - Static Constants
    /// Default cell's height
    static let height: CGFloat = 250
    
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

    // MARK: - Class Methods
    /// Registers the cell with the table view
    /// - Parameter tableView: the table view to register with
    /// - Returns: (optional) returns cell identifier, also available as MessageListCell.identifier
    @discardableResult class func register(with tableView: UITableView?) -> String {
        let aNib = UINib(nibName: nib, bundle: nil)
        tableView?.register(aNib, forCellReuseIdentifier: identifier)
        return identifier
    }
    
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
    /// Called when we know for sure what items we want to display
    /// - Parameters:
    ///   - kind: cell's type
    ///   - items: the items which needs to be displayed in the item stack view
    func configureContent(for kind: Kind, items: [Item]) {
        // Configure variables
        self.kind = kind
        self.items = items
        
        // Configure outlets
        titleLabel.text = title
    }
    
    /// Called from awakeFromNib() in the beggining, when we don't know yet what to display
    func configureLayout() {
        // Nothing to do here yet
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(sender)
    }
}
