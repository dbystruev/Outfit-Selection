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
        let name = occasionNames[indexPath.section]
        guard let label = occasionLabels[name]?[safe: indexPath.row] else {
            debug("ERROR: There are no occasions with name \(name)")
            return
        }
        guard let occasion = Occasions.currentGender.with(name: name).with(label: label).first else {
            debug("ERROR: There are no occasions with name \(name) and label \(label)")
            return
        }
        Occasions.select(title: occasion.title, shouldSelect: !occasion.isSelected)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // Configure the buttons
        configureAllButton()
        configureGoButton()
    }
}
