//
//  Message.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import MessageKit
import SwiftUI

struct Message: MessageType {
    /// The sender of the message
    let sender: SenderType
    
    /// The unique identifier for the message
    let messageId: String
    
    /// The date the message was sent
    let sentDate: Date
    
    /// The kind of the message
    let kind: MessageKind
    
//    init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind) {
//        self.sender = sender
//        self.messageId = messageId
//        self.sentDate = sentDate
//        self.kind = kind
//    }
}
