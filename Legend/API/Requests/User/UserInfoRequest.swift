//
//  UserInfoRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

final class UserInfoRequest: APIRequest {
    typealias APIResourceType = UserInfoResource
    let path = "/api/v1/users.info"
    
    let query: String?
    
    let userId: String?
    let username: String?
    
    init(userId: String) {
        self.userId = userId
        self.username = nil
        self.query = "userId=\(userId)"
    }
    
    init(username: String) {
        self.username = username
        self.userId = nil
        self.query = "username=\(username)"
    }
}

final class UserInfoResource: APIResource {
    var user: User? {
        guard let raw = raw?["user"] else { return nil }
        
        let user = User()
        user.map(raw, realm: nil)
        return user
    }
}

