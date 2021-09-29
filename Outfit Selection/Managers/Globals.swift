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
        enum Feed {
            static let button = ColorCompatibility.label // UIColor(red: 23, green: 23, blue: 23, alpha: 1)
            static let header = ColorCompatibility.label // UIColor(red: 23, green: 23, blue: 23, alpha: 1)
        }
        
        enum Welcome {
            enum Button {
                /// Disabled grey button
                static let disabled = UIColor.gray
                
                /// Enabled black button
                static let enabled = UIColor.black
            }
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
}
