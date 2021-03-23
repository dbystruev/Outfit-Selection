//
//  ShareViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension ShareViewController: UITableViewDataSource {
    /// Titles of the cells
    var cellTitles: [String] {[
        "Instagram Stories",
        "Instagram Post",
        "Pinterest",
        "Telegram",
        "WhatsApp",
        "Facebook",
        "Copy Link",
        "More",
    ]}
    
    /// Names of the images
    var imageNames: [String] {
        cellTitles.map { $0.firstWord.lowercased() }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareCellReuseId", for: indexPath)
        let color = UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1)
        let row = indexPath.row
        
        // Configure cell
        cell.accessoryView?.tintColor = color
        cell.accessoryView?.alpha = 0.5
        cell.textLabel?.font = UIFont(name: "NotoSans-Regular", size: 15)
        cell.textLabel?.text = cellTitles[row]
        cell.textLabel?.textColor = color
        cell.imageView?.image = UIImage(named: imageNames[row])
        
        return cell
    }
}
