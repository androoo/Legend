//
//  UserManager.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

struct UserManager {
    
    static func changes() {
        let request = [
            "msg": "sub",
            "name": "activeUsers",
            "params": []
            ] as [String: Any]
        
        SocketManager.send(request) { _ in }
    }
    
    static func userDataChanges() {
        let request = [
            "msg": "sub",
            "name": "userData",
            "params": []
            ] as [String: Any]
        
        SocketManager.send(request) { _ in }
    }
    
    static func setUserStatus(status: UserStatus, completion: @escaping MessageCompletion) {
        let request = [
            "msg": "method",
            "method": "UserPresence:setDefaultStatus",
            "params": [status.rawValue]
            ] as [String: Any]
        
        SocketManager.send(request) { (response) in
            completion(response)
        }
    }
    
    static func setUserPresence(status: UserPresence, completion: @escaping MessageCompletion) {
        let method = "UserPresence:".appending(status.rawValue)
        
        let request = [
            "msg": "method",
            "method": method,
            "params": []
            ] as [String: Any]
        
        SocketManager.send(request) { (response) in
            completion(response)
        }
    }
    
}
