//
//  Sender.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import MessageKit

struct Sender: SenderType {
    /// The unique String identifier for the sender
    var senderId: String
    
    /// The display name of a sender
    var displayName: String
}
