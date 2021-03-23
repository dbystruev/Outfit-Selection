//
//  ShareViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension ShareViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        switch cellTitles[indexPath.row].lowercased() {
        case "instagram stories":
            shareToInstagramStories(selectedCell)
        case "instagram post":
            shareToInstagramPost(selectedCell)
        case "more":
            shareImage(selectedCell)
        default:
            debug("Selected row \(indexPath.row)")
        }
    }
}
