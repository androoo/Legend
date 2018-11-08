//
//  Permission .swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

enum PermissionType: String {
    case createPublicChannels = "create-c"
    case createDirectMessages = "create-d"
    case createPrivateChannels = "create-p"
    
    case viewStatistics = "view-statistics"
    case viewRoomAdministration = "view-room-administration"
    case viewUserAdministration = "view-user-administration"
    case viewPrivilegedSetting = "view-privileged-setting"
    
    case deleteMessage = "delete-message"
    case forceDeleteMessage = "force-delete-message"
    
    case editMessage = "edit-message"
    
    case pinMessage = "pin-message"
    
    case postReadOnly = "post-readonly"
    
    case removeUser = "remove-user"
    
    case addUserToJoinedRoom = "add-user-to-joined-room"
    case addUserToAnyChannelRoom = "add-user-to-any-c-room"
    case addUserToAnyPrivateRoom = "add-user-to-any-p-room"
}

class Permission: BaseModel {
    var roles = List<String>()
}
