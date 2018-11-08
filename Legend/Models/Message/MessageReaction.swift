//
//  MessageReaction.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class MessageReaction: Object {
    @objc dynamic var emoji: String?
    var usernames = List<String>()
    
    func map(emoji: String, json: JSON) {
        self.emoji = emoji
        
        self.usernames.removeAll()
        json["usernames"].array?.compactMap {
            $0.string
        }.forEach(self.usernames.append)
    }
}
