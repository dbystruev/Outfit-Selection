//
//  URLRequest.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.09.22.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation

extension URLRequest {
    init?(_ url: URL?) {
        guard let url = url else { return nil }
        self.init(url: url)
    }
}
