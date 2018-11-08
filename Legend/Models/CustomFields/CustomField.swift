//
//  CustomField.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CustomField {
    class var type: String {
        return ""
    }
    
    var name: String = ""
    var required: Bool = false
    
    func map(_ values: JSON, realm: Realm?) {
        self.required = values["required"].bool ?? false
    }
    
    static func chooseType(from json: JSON, name: String) -> CustomField {
        var customField: CustomField
        
        switch json["type"].stringValue {
        case SelectField.type:
            customField = SelectField()
        case TextField.type:
            customField = TextField()
        default:
            customField = CustomField()
        }
        
        customField.name = name
        return customField
    }
}
