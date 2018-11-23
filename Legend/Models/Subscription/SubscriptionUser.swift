//
//  SubscriptionUser.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension Subscription {
    var directMessageUser: User? {
        guard let otherUserId = otherUserId else { return nil }
        return User.find(withIdentifier: otherUserId)
    }
    
    var roomOwner: User? {
        guard let roomOwnerId = roomOwnerId else { return nil }
        return User.find(withIdentifier: roomOwnerId)
    }
}
