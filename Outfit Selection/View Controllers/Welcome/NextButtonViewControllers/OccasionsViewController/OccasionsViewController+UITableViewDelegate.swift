//
//  OccasionsViewController+UITableViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        OccasionCell.heigth
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Toggle all occasions with the same title and reload the table
        let occasion = occasions[indexPath.row]
        Occasions.select(title: occasion.title, shouldSelect: !occasion.isSelected)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // Configure the buttons
        configureAllButton()
        configureGoButton()
    }
}
