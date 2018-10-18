//
//  LogManager.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

struct Log {
    static func debug(_ text: String?) {
        #if DEBUG
        guard let text = text else { return }
        print(text)
        #endif 
    }
}
