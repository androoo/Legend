//
//  Message.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum MessageType: String {
    case text
    case textAttachment
    case image
    case video
    case url
    
    case roomNameChanged = "r"
    case userAdded = "au"
    case userREmoved = "ru"
    case userJoined = "uj"
    case userLeft = "ul"
    case userMuted = "user-muted"
    case userUnmuted = "user-unmuted"
    case welcome = "wm"
    case messageRemoved = "rm"
    case subscriptionRoleAdded = "subscription-role-added"
    case subscriptionRoleRemoved = "subscription-role-removed"
    case roomArchived = "room-archived"
    case roomUnarchived = "room-unarchived"
    
    case messagePinned = "message_pinned"
    
    var sequential: Bool {
        let sequential: [MessageType] = [.text, .textAttachment, .messageRemoved]
        return sequential.contains(self)
    }
    
    var actionable: Bool {
        let actionable: [MessageType] = [.text, .textAttachment, .image, .audio, .video, .url]
        return actionable.contains(self)
    }
}

final class Message: BaseModel {
    @objc dynamic var subscription: Subscription?
    @objc dynamic var internalType: String = ""
    @objc dynamic var rid = ""
    
}
