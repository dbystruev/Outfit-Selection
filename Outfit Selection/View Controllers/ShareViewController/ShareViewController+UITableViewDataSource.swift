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
    var cellTypes: [ShareView.ShareType] { ShareView.ShareType.allCases }
    
    /// Names of the images
    var imageNames: [String] {
        cellTypes.map { $0.rawValue.firstWord.lowercased() }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shareCellReuseId", for: indexPath)
        let color = UIColor(red: 0.259, green: 0.259, blue: 0.259, alpha: 1)
        let row = indexPath.row
        
        // Configure cell
        cell.accessoryView?.tintColor = color
        cell.accessoryView?.alpha = 0.5
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: "NotoSans-Regular", size: 15)
        cell.textLabel?.text = cellTypes[row].rawValue.firstCapitalized
        cell.textLabel?.textColor = color
        cell.imageView?.image = UIImage(named: imageNames[row])
        
        return cell
    }
}
