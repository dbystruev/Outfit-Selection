//
//  ProfileViewController+version.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.02.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension ProfileViewController {
    /// Configure the version label at the bottom with the current version and build
    func configureVersionLabel() {
        // Configure the appearance
        versionLabel.font = Globals.Font.Profile.version
        versionLabel.textColor = Globals.Color.Profile.version
        
        // Obtain the version
        guard let infoDictionary = Bundle.main.infoDictionary else {
            debug("WARNING: Can't get info dictionary from the main bundle")
            return
        }
        
        let keys = ["CFBundleShortVersionString", "CFBundleVersion"]
        let versionBundle: [String] = keys.compactMap { key in
            guard let value = infoDictionary[key] else {
                debug("WARNING: No \(key) in info dictionary")
                return nil
            }
            return value as? String
        }
        
        version = versionBundle.isEmpty
        ? nil
        : "v\(versionBundle.joined(separator: " build "))"
        + " " + (NetworkManager.shared.url.host?.dropExtension.dropExtension ?? "")
    }
}
