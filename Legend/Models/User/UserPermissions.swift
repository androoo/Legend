//
//  UserPermissions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import RealmSwift

extension User {
    func rolesInSubscription(_ subscription: Subscription) -> [String] {
        if let roles = subscription.usersRoles.first(where: { $0.user?.identifier == self.identifier })?.roles {
            return Array(roles)
        }
        return []
    }
    
    func hasPermission(_ permission: PermissionType, subscription: Subscription? = nil, realm: Realm? = Realm.current) -> Bool {
        guard let permissionRoles = PermissionManager.roles(for: permission, realm: realm) else { return false }
        
        let roles: [String]
        if let subscription = subscription {
            roles = rolesInSubscription(subscription)
        } else {
            roles = Array(self.roles)
        }
        
        for userRole in roles {
            for permissionRole in permissionRoles where userRole == permissionRole {
                return true
            }
        }
        
        return false
    }
}
