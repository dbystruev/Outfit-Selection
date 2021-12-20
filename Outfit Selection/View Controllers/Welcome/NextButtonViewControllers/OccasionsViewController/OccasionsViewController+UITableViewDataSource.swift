//
//  OccasionsViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController: UITableViewDataSource {
    /// Table rows are occasion labels for the given name
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        occasionLabels[occasionNames[section]]?.count ?? 0
    }
    
    /// Table sections are occasion names
    func numberOfSections(in tableView: UITableView) -> Int {
        occasionNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let occasionCell: OccasionCell = {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: OccasionCell.reuseId
            ) as? OccasionCell else {
                debug("WARNING: Can't dequeue a \(OccasionCell.reuseId) cell from \(tableView)")
                return OccasionCell()
            }
            return cell
        }()
        
        let name = occasionNames[indexPath.section]
        guard let label = occasionLabels[name]?[safe: indexPath.row] else {
            debug("ERROR: There are no occasions with name \(name)")
            return occasionCell
        }
        guard let occasion = Occasions.currentGender.with(name: name).with(label: label).first else {
            debug("ERROR: There are no occasions with name \(name) and label \(label)")
            return occasionCell
        }
        occasionCell.configureContent(with: occasion)
        return occasionCell
    }
}
