//
//  FeedViewController+ButtonDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension FeedViewController: ButtonDelegate {
    func buttonTapped(_ sender: Any) {
        guard let kind = sender as? FeedCell.Kind else { return }
        
        debug(kind)
        performSegue(withIdentifier: FeedItemViewController.segueIdentifier, sender: kind)
    }
}
