//
//  CollectionSelectViewController+Actions.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 10.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - Actions
extension CollectionSelectViewController {
    
    @IBAction func chooseItemsButtonTapped(_ sender: UIButton) {
        debug()
        wishlistViewController?.finishedSelectingCollectionItems()
        dismiss(animated: true, completion: nil)
    }
}
