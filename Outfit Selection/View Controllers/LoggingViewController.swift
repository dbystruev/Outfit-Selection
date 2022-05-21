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
        let selectedBrands = BrandManager.shared.selectedBrandNames
        let brands = selectedBrands.count < 11 ? selectedBrands : nil
        let optionalStats: [String: Any?] = [
            "brands.count": selectedBrands.count,
            "brands": brands,
            "collections.count": Wishlist.collections.count,
            "items.count": Wishlist.items.count,
            "outfits.count": Wishlist.outfits.count,
            "uuid": LoggingViewController.uuid
        ]
        let stats = optionalStats.compactMapValues({ $0 })
        let names = className.drop(suffix: "ViewController").splitBefore { $0.isUppercased }
        let name = String(names.joined(separator: " "))
        AppsFlyerLib.shared().logEvent(name, withValues: stats)
        AppDelegate.logYandex(event: name, parameters: stats)
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
