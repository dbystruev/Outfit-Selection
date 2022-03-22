//
//  ChatViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import MessageKit

class ChatViewController: MessagesViewController {
    /// The user we are sending from
    let currentUser = Sender(senderId: "currentUser", displayName: "Me")
    
    /// The Get Outfit user
    let otherUser = Sender(avatar: Globals.Image.logo, senderId: "otherUser", displayName: "Get Outfit")
    
    /// The list of messages to display
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up messages
        messages.append(
            Message(
                sender: currentUser,
                messageId: "1",
                sentDate: Date().addingTimeInterval(-86400),
                kind: .text("What occasions do you have?")
            )
        )
        
        messages.append(contentsOf: Occasions.titles.sorted().map {
            Message(sender: otherUser, messageId: $0, sentDate: Date(), kind: .text($0))
        })
        
        // Set up delegates
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
}
