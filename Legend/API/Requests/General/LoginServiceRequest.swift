//
//  LoginServiceRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/21/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

class LoginServicesRequest: APIRequest {
    typealias APIResourceType = LoginServicesResource
    
    let requiredVersion: Version = Version(0, 64, 0)
    let path = "/api/v1/settings.oauth"
}

class LoginServicesResource: APIResource {
    var loginServices: [LoginService] {
        return raw?["services"].arrayValue.compactMap {
            let service = LoginService()
            service.map($0, realm: nil)
            
            guard service.isValid, service.service != nil else {
                return nil
            }
            
            return service
        } ?? []
    }
}
