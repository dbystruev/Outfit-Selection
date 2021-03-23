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
        debug(indexPath.row)
    }
}
