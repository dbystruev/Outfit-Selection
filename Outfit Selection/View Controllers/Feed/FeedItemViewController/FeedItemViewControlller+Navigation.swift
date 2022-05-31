//
//  FeedItemViewControlller+Navigation.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 31.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension FeedItemViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case CollectionNameViewController.segueIdentifier:
            // Make sure destination is feedItem view controller
            guard let destination = segue.destination as? CollectionNameViewController else {
                debug("WARNING: \(segue.destination) is not \(CollectionNameViewController.self)")
                return
            }
            destination.configure(textField: name ?? "", sender: sender)
            
        default:
            debug("WARNING: Unknown segue identifier", segue.identifier)
        }
    }
}
