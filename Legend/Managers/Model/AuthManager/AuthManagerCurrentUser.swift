//
//  AuthManagerCurrentUser.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

extension AuthManager {
    /**
     - returns: Current user object, if exists.
     */
    static func currentUser(realm: Realm? = Realm.current) -> User? {
        return isAuthenticated(realm: realm)?.user
    }
}
