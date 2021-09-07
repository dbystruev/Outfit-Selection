//
//  WishlistViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension WishlistViewController: ButtonDelegate {
    /// Called when item or outfit is selected in new collection creation
    /// - Parameter sender: item or outfit selected
    func buttonTapped(_ sender: Any) {
        debug("\(sender)")
    }
}
