//
//  VersionMiddleware.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/19/18.
//  Copyright © 2018 And. All rights reserved.
//

struct VersionMiddleware: APIRequestMiddleware {
    weak var api: API?
    
    init(api: API) {
        self.api = api
    }
    
    func handle<R>(_ request: inout R) -> APIError? where R : APIRequest {
        guard let api = api else {
            return nil
        }
        
        if api.version < request.requiredVersion {
            return APIError.version(available: api.version, required: request.requiredVersion)
        }
        
        return nil 
    }
}
