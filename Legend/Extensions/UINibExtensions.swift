//
//  UINibExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UINib {
    
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}
