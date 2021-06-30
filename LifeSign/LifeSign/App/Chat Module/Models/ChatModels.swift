//
//  ChatModels.swift
//  LifeSign
//
//  Created by Haider Ali on 22/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import MessageKit
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var isRead: Bool
    var isSent: Bool
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
