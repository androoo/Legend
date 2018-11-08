//
//  ChannelModelMapping.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/27/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension Channel: ModelMappeable {
    func map(_ values: JSON, realm: Realm?) {
        self.name = values["name"].stringValue
    }
}
