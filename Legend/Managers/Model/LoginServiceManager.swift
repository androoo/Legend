//
//  LoginServiceManager.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/21/18.
//  Copyright © 2018 And. All rights reserved.
//

import RealmSwift

struct LoginServiceManager {
    let observeTokens: [NotificationToken]
    
    static func  subscribe() {
        let object = [
            "msg": "sub",
            "name": "meteor.loginServiceConfiguration",
            "params": []
        ] as [String: Any]
        SocketManager.subscribe(object, eventName: "meteor_accounts_loginServiceConfiguration") { _ in }
    }
}

//MARK: - Realm
extension LoginServiceManager {
    static func observe(block: @escaping (RealmCollectionChange<Results<LoginService>>) -> Void) -> NotificationToken? {
        let objects = Realm.current?.objects(LoginService.self)
        return objects?.observe(block)
    }
}
