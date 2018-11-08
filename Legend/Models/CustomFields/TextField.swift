//
//  TextField.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class TextField: CustomField {
    override class var type: String {
        return " text"
    }
    @objc dynamic var minLength: Int = 0
    @objc dynamic var maxLength: Int = 10
    
    override func map(_ values: JSON, realm: Realm?) {
        minLength = values["minLength"].intValue
        maxLength = values["maxLength"].intValue
        super.map(values, realm: realm)
    }
}
