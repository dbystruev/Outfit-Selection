//
//  Link.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import MessageKit
import UIKit

public struct Link: LinkItem {
    // MARK: - Public Properties
    /// The message attributed text
    public var attributedText: NSAttributedString?
    
    /// The teaser text
    public var teaser = ""
    
    /// The message text
    public var text: String?
    
    /// The kind of message
    public var textKind: MessageKind?
    
    /// The thumbnail image
    public var thumbnailImage = UIImage()
    
    /// The title
    public var title: String?
    
    /// The URL
    public var url: URL
    
    // MARK: - Init
    /// Creates a Link instance from the provided URL
    init(_ url: URL, text: String) {
        self.text = text
        self.url = url
    }
    
    /// Creates a Link instance from the provided string
    /// This initializer returns nil if the string doesn’t represent a valid URL
    init?(_ string: String, text: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url, text: text)
    }
}
