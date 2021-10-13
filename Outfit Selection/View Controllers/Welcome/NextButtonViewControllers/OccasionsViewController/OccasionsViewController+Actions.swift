//
//  OccasionsViewController+Actions.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 11.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsViewController {
    // MARK: - Actions
    override func nextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: ProgressViewController.segueIdentifier, sender: sender)
    }
    
    @IBAction func selectAllButtonTapped(_ sender: SelectableButtonItem) {
        // Switch the selection
        sender.isButtonSelected.toggle()
        let isSelected = sender.isButtonSelected
        
        // Select / deselect all occasions save the selection to permanent storage
        Occasion.all.forEach { $0.value.selectWithoutSaving(isSelected) }
        Occasion.saveSelectedOccasions()
        
        // Reload occasions and enable / disable go button
        occasionsTableView.reloadData()
        configureGoButton()
    }
}
