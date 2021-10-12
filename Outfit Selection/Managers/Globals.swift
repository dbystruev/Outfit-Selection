//
//  Globals.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

enum Globals {
    enum Color {
        /// Button Colors
        enum Button {
            
            /// Gender button colors
            enum Gender {
                /// Title color for gender buttons
                static let titleColor = WhiteLabel.Color.Button.Gender.titleColor
            }
            
            /// Disabled color for welcome button
            static let disabled = WhiteLabel.Color.Button.disabled
            
            /// Enabled color for welcome button
            static let enabled = WhiteLabel.Color.Button.enabled
            
            /// Title color for buttons
            static let titleColor = WhiteLabel.Color.Button.titleColor
        }
        
        /// Feed colors
        enum Feed {
            /// Feed button color
            static let button = ColorCompatibility.label // UIColor(red: 23, green: 23, blue: 23, alpha: 1)
            
            /// Feed header color
            static let header = ColorCompatibility.label // UIColor(red: 23, green: 23, blue: 23, alpha: 1)
        }
        
        /// Colors for onboarding screens
        enum Onboarding {
            /// Onboarding background color
            static let background = UIColor(red: 81, green: 97, blue: 95, alpha: 1)
            
            /// Onboarding button color
            static let button = UIColor(red: 116, green: 138, blue: 132, alpha: 1)
            
            /// Onboarding dash color
            static let dash = UIColor(red: 116, green: 138, blue: 132, alpha: 1)
            
            /// Onboarding dot color
            static let dot = UIColor(red: 224, green: 224, blue: 224, alpha: 1)
            
            /// Onboarding text color
            static let text = UIColor(red: 252, green: 252, blue: 252, alpha: 1)
        }
    }
    
    enum Font {
        enum Feed {
            /// UIFont(name: "NotoSans-Regular", size: 12)
            static let button = UIFont(name: "NotoSans-Regular", size: 12)!
            
            /// UIFont(name: "NotoSans-SemiBold", size: 16)
            static let header = UIFont(name: "NotoSans-SemiBold", size: 16)!
        }
    }
    
    enum Image {
        /// Logo image
        static let logo = UIImage(named: WhiteLabel.logo)!
    }
}
