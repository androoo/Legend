//
//  Weak.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

struct Weak<T: AnyObject> {
    weak var value: T?
    init(_ value: T) {
        self.value = value
    }
}
