//
//  WhiteLabel.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 30.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// White label to change app appearance
struct WhiteLabel {
    // MARK: - Types
    /// White label app edition — Concept Group, Get Outfit, or Raskroi
    enum Kind: String {
        case concept
        case raskroi
        case getoutfit
    }
    
    // MARK: - Static Stored Properties
    /// The bundle ID of current app
    static let bundleID = Bundle.main.bundleIdentifier
    
    /// App edition
    static let kind: Kind = {
        switch bundleID?.lastComponent(separator: ".") {
        case "concept":
            return .concept
        case "raskroi":
            return .raskroi
        default:
            return .getoutfit
        }
    }()
    
    /// concept, getoutfit, or raskroi
    static let edition = kind.rawValue
    
    /// Concept Group, Get Outfit, or Raskroi
    static let fullName: String = {
        switch kind {
        case .concept:
            return "Concept Group"
        case .getoutfit:
            return "Get Outfit"
        case .raskroi:
            return "Raskroi"
        }
    }()
    
    /// Main logo name: concept_main, getoutfit_main, or raskroi_main
    static let logo = "\(edition)_main"
    
    /// Share logo name: concept_share, getoutfit_share, or raskroi_share
    static let logoShare = "\(edition)_share"
    
    /// Colors
    enum Color {
        /// Background colors
        enum Background {
            /// Customized light background color
            static let light: UIColor = kind == .getoutfit
                ? UIColor(
                    red: 0.46932125089999999,
                    green: 0.53824871780000005,
                    blue: 0.51836496590000003,
                    alpha: 1
                )
                : .white
        }
        
        /// Progress bar colors
        enum Progress {
            /// Progress bar tint color
            static let progressTintColor: UIColor = kind == .getoutfit
                ? UIColor(
                    red: 0.32052502040000003,
                    green: 0.37435173989999998,
                    blue: 0.37976023549999999,
                    alpha: 1
                )
                : .black

            /// Progress bar track tint color
            static let trackTintColor: UIColor = kind == .getoutfit
                ? UIColor(
                    red: 0.99991279840000002,
                    green: 1,
                    blue: 0.99988144639999998,
                    alpha: 1
                )
                : .lightGray
        }
        
        /// Text colors
        enum Text {
            static let button: UIColor = kind == .getoutfit
                ? UIColor(
                    red: 0.25958698990000001,
                    green: 0.2596296072,
                    blue: 0.259577632,
                    alpha: 1
                )
                : .black
            
            /// Customized text label color
            static let label: UIColor = kind == .getoutfit
                ? .white
                : .black
        }
        
        /// Button colors
        enum Button {
            
            /// Gender button colors
            enum Gender {
                /// Title color for gender buttons
                static let titleColor: UIColor = kind == .getoutfit
                ? UIColor(
                    red: 0.25958698990000001,
                    green: 0.2596296072,
                    blue: 0.259577632,
                    alpha: 1
                )
                : .black
            }
            
            /// Button disabled color
            static let disabled: UIColor = kind == .getoutfit
            ? UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
            : .lightGray
            
            /// Button enabled color
            static let enabled: UIColor = kind == .getoutfit
            ? UIColor(red: 0.455, green: 0.541, blue: 0.518, alpha: 1)
            : .black
            
            /// Title color buttons
            static let titleColor: UIColor = kind == .getoutfit
            ? UIColor(
                red: 0.99991279840000002,
                green: 1,
                blue: 0.99988144639999998,
                alpha: 1
            )
            : .white
        }
    }
    
    /// Texts
    enum Text {
        /// Gender screen text
        enum Gender {
            /// Gender screen text below logo
            static let description = "\(fullName) — your personal styling platform"
        }
    }
}
