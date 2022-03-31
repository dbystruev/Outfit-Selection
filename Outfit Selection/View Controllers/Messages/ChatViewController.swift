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
        // User question
        messages.append(Message(
            sender: currentUser,
            messageId: "0",
            sentDate: Date().addingTimeInterval(-86400),
            kind: .text("What occasions do you have?")
        ))
        
        // Response: image, link, and text
        let otherUserMessages: [MessageKind] = [
            .photo(Image(named: "barbecue")!),
//            .linkPreview(Link(
//                "https://www.getoutfit.app/items/?id=in.(1392785176,1613430577,170020175348,17037618636363633263,14569985554653)",
//                text: ""
//            )!),
            .text("Barbecue outfit"),
        ]
        
        messages.append(contentsOf: otherUserMessages.enumerated().map { Message(
            sender: otherUser,
            messageId: "\(messages.count + $0)",
            sentDate: Date(),
            kind: $1
        )})
        
        // Set up delegates
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }
}
