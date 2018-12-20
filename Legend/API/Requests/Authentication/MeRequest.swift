//
//  MeRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 12/19/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON

final class MeRequest: APIRequest {
    typealias APIResourceType = MeResource
    let path = "/api/v1/me"
}

final class MeResource: APIResource {
    var user: User? {
        guard let raw = raw else { return nil }
        let user = User()
        user.map(raw, realm: nil)
        return user
    }
    
    var errorMessage: String? {
        return raw?["error"].string 
    }
}
