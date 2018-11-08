//
//  SelectField.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class SelectField: CustomField {
    override class var type: String {
        return "select"
    }
    
    var options: [String] = []
    @objc dynamic var defaultValue: String = ""
    
    override func map(_ values: JSON, realm: Realm?) {
        options = values["options"].arrayValue.map { $0.stringValue }
        defaultValue = values["defaultValue"].stringValue
        super.map(values, realm: realm)
    }
}
