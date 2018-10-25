//
//  LoginRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/19/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

typealias LoginParams = [String: Any]

final class LoginRequest: APIRequest {
    typealias APIResourceType = LoginResource
    let method: HTTPMethod = .post
    let path = "/api/v1/login"
    
    let params: LoginParams
    
    init(params: LoginParams) {
        self.params = params
    }
    
    func body() -> Data? {
        return JSON(params).description.data(using: .utf8)
    }
}

final class LoginResource: APIResource {
    var error: String? {
        return raw?["error"].string
    }
    
    var status: String? {
        return raw?["status"].string
    }
    
    var data: JSON? {
        return raw?["data"]
    }
    
    var authToken: String? {
        return data?["authToken"].string
    }
    
    var userId: String? {
        return data?["userId"].string
    }
}

typealias LoginResponse = APIResponse<LoginResource>
