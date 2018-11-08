//
//  CommandModelMapping.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/27/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON
import RealmSwift

extension Command: ModelMappeable {
    func map(_ values: JSON, realm: Realm?) {
        self.command = values["command"].stringValue
        self.clientOnly = values["params"].boolValue
        self.params = values["params"].stringValue
        self.desc = values["description"].stringValue 
    }
}
