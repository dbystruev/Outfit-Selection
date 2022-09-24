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
            return "Concept Group"~
        case .getoutfit:
            return "Get Outfit"~
        case .raskroi:
            return "Raskroi"~
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
            static let light = kind == .getoutfit ? #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.8274509804, alpha: 1) : .white
            
            /// Customized onboarding background color
            static let onboarding = kind == .getoutfit ? #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.8274509804, alpha: 1) : .white
        }
        
        /// Button colors
        enum Button {
            
            /// Gender button colors
            enum Gender {
                /// Title color for gender buttons
                static let titleColor = kind == .getoutfit ? #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1215686275, alpha: 1) : .black
            }
            
            /// Button disabled color
            static let disabled = kind == .getoutfit ? #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.8274509804, alpha: 1) : .lightGray
            
            /// Button enabled color
            static let enabled = kind == .getoutfit ? #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1215686275, alpha: 1) : .black
            
            /// Title color buttons
            static let titleColor = kind == .getoutfit ? #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.8274509804, alpha: 1) : .white
        }
        
        /// Progress bar colors
        enum Progress {
            /// Progress bar tint color
            static let progressTintColor = kind == .getoutfit ? #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1215686275, alpha: 1) : .black
            
            /// Progress bar track tint color
            static let trackTintColor = kind == .getoutfit ? #colorLiteral(red: 0.8470588235, green: 0.8745098039, blue: 0.8274509804, alpha: 1) : .lightGray
        }
        
        /// Text colors
        enum Text {
            static let button = kind == .getoutfit ? #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1215686275, alpha: 1) : .black
            
            /// Customized text label color
            static let label = kind == .getoutfit ? #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1215686275, alpha: 1) : .black
            
            /// Onboarding text color
            static let onboarding = kind == .getoutfit ? #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1215686275, alpha: 1) : .black
        }
    }
    
    /// Texts
    enum Text {
        /// Gender screen text
        enum Gender {
            /// Gender screen text below logo
            static let description = "\(fullName) — " + "your personal styling platform"~
        }
    }
}
