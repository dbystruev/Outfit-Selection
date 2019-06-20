//
//  ViewController+UIDocumentPickerDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - UIDocumentPickerDelegate
extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let index = selectedButtonIndex else { return }
        guard index < scrollViews.count else { return }
        let scrollView = scrollViews[index]
        for url in urls {
            guard let data = try? Data(contentsOf: url) else { continue }
            scrollView.insert(image: UIImage(data: data))
        }
    }
}
