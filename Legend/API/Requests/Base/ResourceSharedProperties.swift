//
//  ResourceSharedProperties.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/21/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

protocol ResourceSharedProperties {
    var error: String? { get }
    var errorType: String? { get }
    var success: Bool? { get }
}

extension ResourceSharedProperties where Self: APIResource {
    var error: String? {
        return raw?["error"].string
    }
    
    var errorType: String? {
        return raw?["errorType"].string
    }
    
    var success: Bool? {
        return raw?["success"].boolValue
    }
}
