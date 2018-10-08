//
//  RealmCurrent.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

var realmConfiguration: Realm.Configuration?

extension Realm {
    static var current: Realm? {
        if let configuration = realmConfiguration {
            return try? Realm(configuration: configuration)
        } else {
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            return try? Realm(configuration: configuration)
        }
    }
}
