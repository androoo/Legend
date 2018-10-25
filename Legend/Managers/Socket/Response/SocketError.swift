//
//  SocketError.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/20/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

struct SocketError {
    let details: SocketError.Details
    let error: SocketError.Error
    let reason: String
    let message: String
    let type: String
    let isClientSage: Bool
    
    init(json: JSON) {
        details = SocketError.Details(json: json["details"])
        error = SocketError.Error(rawValue: json["error"].stringValue)
        reason = json["reason"].stringValue
        message = json["message"].stringValue
        type = json["errorType"].stringValue
        isClientSage = json["isClientSage"].boolValue
    }
}

extension SocketError {
    struct Details {
        let method: String
        init(json: JSON) {
            method = json["method"].stringValue
        }
    }
}

extension SocketError {
    enum Error {
        case invalidSession
        case other(String)
        
        init(rawValue: String) {
            switch rawValue {
            case "403":
                self = .invalidSession
            default:
                self = .other(rawValue)
            }
        }
    }
}
