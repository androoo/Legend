//
//  Auth.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

final class Auth: Object {
    //Server
    @objc dynamic var serverURL = ""
    @objc dynamic var serverVersion = ""
    
    var apiHost: URL? {
        guard let socketURL = URL(string: serverURL, scheme: "https") else {
            return nil
        }
        
        return socketURL.httpServerURL()
    }
    
    @objc dynamic var settings: AuthSettings?
    
    @objc dynamic var token: String?
    @objc dynamic var tokenExpires: Date?
    @objc dynamic var lastAccess: Date?
    @objc dynamic var lastSubscriptionFetchWithLastMessage: Date?
    @objc dynamic var lastRoomWithLastMessage: Date?
    @objc dynamic var userId: String?
    
    // Subscriptions
    let subscriptions = LinkingObjects(fromType: Subscription.self, property: "auth")
    
    // Primary key from Auth
    override static func primaryKey() -> String? {
        return "serverURL"
    }
    
    // MARK: Internal
    
    // This key controls if the first channel (based on firstChannelAfterLogin) setting
    // was already opened on this authentication object
    @objc dynamic var internalFirstChannelOpened = true
}
