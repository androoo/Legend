//
//  String+Random.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension String {
    static func random(_ length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = Int(arc4random_uniform(UInt32(base.count)))
            randomString.append(base[base.index(base.startIndex, offsetBy: randomValue)])
        }
        return randomString
    }
}
