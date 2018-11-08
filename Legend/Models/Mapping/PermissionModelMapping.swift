//
//  PermissionModelMapping.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension Permission: ModelMappeable {
    func map(_ values: JSON, realm: Realm?) {
        if self.identifier == nil {
            self.identifier = values["_id"].string
        }
        
        if let roles = values["roles"].array?.compactMap({ $0.string }) {
            self.roles.removeAll()
            self.roles.append(contentsOf: roles)
        }
    }
}
