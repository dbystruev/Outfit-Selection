//
//  Message.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import MessageKit

public struct Message: MessageType {
    /// The sender of the message
    public let sender: SenderType
    
    /// The unique identifier for the message
    public let messageId: String
    
    /// The date the message was sent
    public let sentDate: Date
    
    /// The kind of the message
    public let kind: MessageKind
    
//    init(sender: SenderType, messageId: String, sentDate: Date, kind: MessageKind) {
//        self.sender = sender
//        self.messageId = messageId
//        self.sentDate = sentDate
//        self.kind = kind
//    }
}
