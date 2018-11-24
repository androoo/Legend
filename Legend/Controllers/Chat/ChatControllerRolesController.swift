//
//  ChatControllerRolesController.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

extension ChatViewController {
    func updateSubscriptionRoles() {
        guard let client = API.current()?.client(SubscriptionsClient.self),
            subscription = subscription,
            subscription.type != .directMessage else {
                return
        }
        client.fetchRoles(subscription: subscription)
    }
}
