//
//  ModelMappeable.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/25/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Realm

public typealias UpdateBlock<T> = (_ object: T?) -> Void

protocol ModelMappeable {
    func map(_ values: JSON, realm: Realm?)
}

extension ModelMappeable where Self: BaseModel {
    static func getOrCreate(realm: Realm, values: JSON?, updates: UpdateBlock<Self>?) -> Self {
        var object: Self!
        
        if let primaryKey = values?["_id"].string {
            if let newObject = realm.object(ofType: Self.self, forPrimaryKey: primaryKey as AnyObject) {
                object = newObject
            }
        }
        
        if object == nil {
            object = Self()
        }
        
        if let values = values {
            object.map(values, realm: realm)
        }
        
        updates?(object)
        return object
    }
}
