//
//  SearchItemsViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 31.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension SearchItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        // Instantiate a view controller from wishlist storyboard
        let wishlistStoryboard = UIStoryboard(name: "Wishlist", bundle: nil)
        let identifier = String(describing: ItemViewController.self).decapitalizingFirstLetter
        let viewController = wishlistStoryboard.instantiateViewController(withIdentifier: identifier)
        
        // Try to cast it to item view controller
        guard let itemViewController = viewController as? ItemViewController else {
            debug("WARNING: Can't cast \(viewController) to \(ItemViewController.self)")
            return
        }
        
        // Configure and push item view controller
        itemViewController.configure(with: searchItems?[indexPath.row], image: nil, isAddEnabled: true)
        itemViewController.parentNavigationController = parentNavigationController
        
        // Show item view controller witn item
        showDetailViewController(itemViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        debug(indexPath.row)
    }
}
