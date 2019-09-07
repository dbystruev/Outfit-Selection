//
//  OutfitViewController+UIImagePickerControllerDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

extension OutfitViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let index = selectedButtonIndex else { return }
        let scrollView = scrollViews[index]
        scrollView.insertAndScroll(image: image)
        dismiss(animated: true)
    }
}
