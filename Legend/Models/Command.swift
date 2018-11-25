//
//  Command.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/27/18.
//  Copyright © 2018 And. All rights reserved.
//

import RealmSwift

class Command: Object {
    @objc dynamic var command: String = ""
    @objc dynamic var clientOnly: Bool = false
    @objc dynamic var params: String = ""
    @objc dynamic var desc: String = ""
    
    static func primaryKeys() -> String {
        return "command"
    }
}
