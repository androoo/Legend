//
//  UserDefaults+Group.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension UserDefaults {
    static var group: UserDefaults {
        guard let defaults = UserDefaults(suiteName: AppGroup.identifier) else {
            fatalError("Could not initialize UserDefaults with suiteName \(AppGroup.identifier)")
        }
        
        return defaults
    }
}
