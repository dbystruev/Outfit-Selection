//
//  OccasionsPopupViewController+UIPickerViewDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension OccasionsPopupViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { occasionNames[row] }
}
