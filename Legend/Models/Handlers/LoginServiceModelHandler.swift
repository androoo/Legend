//
//  LoginServiceModelHandler.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/25/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension LoginService: ModelHandler {
    func add(_ values: JSON, realm: Realm) {
        map(values, realm: realm)
        realm.add(self, update: true)
    }
    
    func update(_ values: JSON, realm: Realm) {
        map(values, realm: realm)
        realm.add(self, update: true)
    }
    
    func remove(_ values: JSON, realm: Realm) {
        realm.delete(self)
    }
}
