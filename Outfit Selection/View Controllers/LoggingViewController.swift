//
//  LoggingViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import AppsFlyerLib
import UIKit

class LoggingViewController: UIViewController {
    // MARK: - Static Properties
    private static var uuid: String?
    
    // MARK: - Static Methods
    static func generateUUID() {
        guard uuid == nil else { return }
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return }
        LoggingViewController.uuid = uuid
    }
    
    // MARK: - Custom Methods
    func log() {
        let dictinary = [
            "brands": BrandManager.shared.selectedBrandNames,
            "collections": Wishlist.collections.count,
            "items": Wishlist.items.count,
            "outfits": Wishlist.outfits.count,
            "uuid": LoggingViewController.uuid as Any
        ]
        let names = String(describing: Self.self).drop(suffix: "ViewController").splitBefore { $0.isUppercased }
        let name = String(names.joined(separator: " "))
        AppsFlyerLib.shared().logEvent(name, withValues: dictinary)
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LoggingViewController.generateUUID()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log()
    }
}
