//
//  Email.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

final class Email: Object {
    @objc dynamic var email = ""
    @objc dynamic var verified = false 
}
