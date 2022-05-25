//
//  Pick.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 23.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

struct Pick: Codable {
    let type: PickType
    var filters: [PickFilter] = []
    let limit: Int?
    var subtitles: [String] = []
    let title: String
    
    // MARK: - Init
    /// - Parameters:
    ///   - type: PickType
    ///   - filters: filters for PickType
    ///   - limit: limit for get items
    ///   - subtitles: subtitles for sections
    ///   - title: title for section
    init(
        _ type: PickType,
        filters: [PickFilter] = [],
        limit: Int? = nil,
        subtitles: [String] = [],
        title: String
    ) {
        self.type = type
        self.filters = filters
        self.limit = limit
        self.subtitles = subtitles
        self.title = title
    }
}

extension Pick: Hashable {}
