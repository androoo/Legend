//
//  DeleteMessageRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

final class DeleteMessageRequest: APIRequest {
    typealias APIResourceType = DeleteMessageResource
    let requiredVersion = Version(0, 48, 0)
    
    let method: HTTPMethod = .post
    let path = "/api/v1/chat.delete"
    
    let roomId: String
    let msgId: String
    let asUser: Bool
    
    init(roomId: String, msgId: String, asUser: Bool) {
        self.msgId = msgId
        self.roomId = roomId
        self.asUser = asUser
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "msgId": msgId,
            "asUser": asUser
            ])
        
        return body.rawString()?.data(using: .utf8)
    }
}

final class DeleteMessageResource: APIResource {
    var success: Bool? {
        return raw?["success"].boolValue
    }
}

