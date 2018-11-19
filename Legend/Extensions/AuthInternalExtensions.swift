//
//  AuthInternalExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import RealmSwift

extension Auth {
    
    /**
     This option updates internal value of firstChannelAfterLogin
     */
    
    func setFirstChannelOpened() {
        Realm.executeOnMainThread { (realm) in
            self.internalFirstChannelOpened = true
            realm.add(self, update: true)
        }
    }
}
