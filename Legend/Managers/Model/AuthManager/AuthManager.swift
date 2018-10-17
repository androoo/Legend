//
//  AuthManager.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import RealmSwift
import Realm

struct AuthManager {
    
    static func isAuthenticated(realm: Realm? = Realm.current) -> Auth? {
        guard let realm = realm else { return nil }
        return realm.objects(Auth.self).sorted(byKeyPath: "lastAccess", ascending: false).first
    }
}
