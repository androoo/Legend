//
//  RunCommandSucceeded.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

typealias RunCommandSucceeded = (RunCommandResource) -> Void

final class RunCommandRequest: APIRequest {
    typealias APIResourceType = RunCommandResource
    
    let method: HTTPMethod = .post
    let path = "/api/v1/commands.run"
    let requiredVersion = Version(0, 60, 0)
    
    let command: String
    let params: String
    let roomId: String
    
    init(command: String, params: String, roomId: String) {
        self.command = command
        self.params = params
        self.roomId = roomId
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "command": command,
            "params": params
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class RunCommandResource: APIResource {
    var success: Bool? {
        return raw?["success"].boolValue
    }
}

