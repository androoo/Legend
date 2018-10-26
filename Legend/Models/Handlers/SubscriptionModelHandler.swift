//
//  SubscriptionModelHandler.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/26/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension Subscription: ModelHandler {
    func add(_ values: JSON, realm: Realm) {
        map(values, realm: realm)
    }
    
    func update(_ values: JSON, realm: Realm) {
        map(values, realm: realm)
    }
    
    func remove(_ values: JSON, realm: Realm) {
        realm.delete(self)
    }
}
