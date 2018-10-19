//
//  APIResource.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/19/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON

class APIResource {
    let raw: JSON?
    
    required init(raw: JSON?) {
        self.raw = raw 
    }
}
