//
//  String+dropExtension.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

extension String {
    var dropExtension: String {
        split(separator: ".").dropLast().joined(separator: ".")
    }
}
