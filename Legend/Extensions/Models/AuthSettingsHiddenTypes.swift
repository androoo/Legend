//
//  AuthSettingsHiddenTypes.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension AuthSettings {
    var hiddenTypes: Set<MessageType> {
        var hiddenTypes = Set<MessageType>()
        
        if hideMessageUserJoined { hiddenTypes.insert(.userJoined) }
        if hideMessageUserLeft { hiddenTypes.insert(.userLeft) }
        if hideMessageUserAdded { hiddenTypes.insert(.userAdded) }
        if hideMessageUserRemoved { hiddenTypes.insert(.userRemoved) }
        if hideMessageUserMutedUnmuted {
            hiddenTypes.insert(.userMuted)
            hiddenTypes.insert(.userUnmuted)
        }
        
        return hiddenTypes
    }
}
