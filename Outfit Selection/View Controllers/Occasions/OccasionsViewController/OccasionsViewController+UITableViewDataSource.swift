//
//  OccasionsViewController+UITableViewDataSource.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { Occasion.all.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let occasionCell: OccasionCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OccasionCell.reuseId) as? OccasionCell else {
                debug("WARNING: Can't dequeue a \(OccasionCell.reuseId) cell from \(tableView)")
                return OccasionCell()
            }
            return cell
        }()
        
        occasionCell.configure(with: Occasion.all[indexPath.row])
        return occasionCell
    }
}
