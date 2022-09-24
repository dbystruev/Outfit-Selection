//
//  CollectionNameViewController+UITextFieldDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 06.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UITextFieldDelegate
extension CollectionNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if !addItemsButton.isHidden {
            addItemsButtonTapped(addItemsButton)
        }
        return true
    }
}
