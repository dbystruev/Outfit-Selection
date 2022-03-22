//
//  ChatViewController+MessagesDisplayDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 22.03.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import MessageKit

extension ChatViewController: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = messages[indexPath.section].sender as? Sender
        avatarView.contentMode = .scaleAspectFit
        avatarView.image = sender?.avatar
    }
}
