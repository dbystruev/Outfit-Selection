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
            static let background = WhiteLabel.Color.Background.onboarding
            
            /// Onboarding dash color
            static let dash = Button.enabled
            
            /// Onboarding dot color
            static let dot = WhiteLabel.Color.Button.disabled
            
            /// Onboarding text color
            static let text = WhiteLabel.Color.Text.onboarding
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
