//
//  Mention.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

final class Mention: Object {
    @objc dynamic var userId: String?
    @objc dynamic var realName: String?
    @objc dynamic var username: String?
}
