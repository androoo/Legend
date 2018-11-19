//
//  PostMessageRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

final class PostMessageRequest: APIRequest {
    typealias APIResourceType = PostMessageResource
    
    let method: HTTPMethod = .post
    let path = "/api/v1/chat.postMessage"
    
    let roomId: String
    let text: String
    
    init(roomId: String, text: String) {
        self.roomId = roomId
        self.text = text
    }
    
    func body() -> Data? {
        let body = JSON([
            "roomId": roomId,
            "text": text
            ])
        return body.rawString()?.data(using: .utf8)
    }
}

final class PostMessageResource: APIResource {
    var message: Message? {
        guard let rawMessage = raw?["message"] else { return  nil }
        
        let message = Message()
        message.map(rawMessage, realm: nil)
        return message
    }
}
