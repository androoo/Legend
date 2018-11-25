//
//  UserQueries.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import RealmSwift

enum UserQueryParameter {
    case userId(String)
    case username(String)
}

extension User {
    static func find(username: String, realm: Realm? = Realm.current) -> User? {
        guard
            let realm = realm,
            let user = realm.objects(User.self).filter("username = %@", username).first
            else {
                return nil
        }
        
        return user
    }
    
    static func fetch(by queryParameter: UserQueryParameter, realm: Realm? = Realm.current, api: API? = API.current(), completion: @escaping (User?) -> Void) {
        guard
            let realm = realm,
            let api = api
            else {
                return
        }
        
        let request: UserInfoRequest
        switch queryParameter {
        case .userId(let userId):
            request = UserInfoRequest(userId: userId)
        case .username(let username):
            request = UserInfoRequest(username: username)
        }
        
        api.fetch(request) { response in
            switch response {
            case .resource(let resource):
                guard let user = resource.user else { return completion(nil) }
                
                realm.execute({ realm in
                    let user = user
                    realm.add(user, update: true)
                })
                
                completion(user)
            case .error:
                completion(nil)
            }
        }
    }
}