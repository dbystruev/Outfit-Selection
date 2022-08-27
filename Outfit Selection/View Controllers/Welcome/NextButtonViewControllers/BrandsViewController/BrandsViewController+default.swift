//
//  BrandsViewController+default.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.08.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

extension BrandsViewController {
    /// Strong connection to brands view controller in order for ARC not to free it
    static public var `default`: BrandsViewController?
}
