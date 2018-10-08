//
//  AuthSettings.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum RegistrationFormAccess: String {
    case isPublic = "Public"
    case isDisabled = "Disabled"
    case isSecretURL = "Secret URL"
}

struct AuthSettingsDefaults {
    static let messageGroupingPeriod = 900
}

final class AuthSettings: Object {
    @objc dynamic var siteURL: String?
    @objc dynamic var cdnPrefixURL: String?
    
    //Server information
    @objc dynamic var serverName: String?
    @objc dynamic var allowspecialCharsOnLegendNames = false
    
    // Legends
    @objc dynamic var followingLegends = true
    @objc dynamic var storeLastMessage = true
    
    // Authentication methods
    @objc dynamic var isUsernameEmailAuthenticationEnabled = false
    @objc dynamic var isPasswordResetEnabled = true
    
    @objc dynamic var isCASEnabled = false
    @objc dynamic var casLoginUrl: String?
    
    @objc dynamic var firstChannelAfterLogin: String?
    
    // Authentication Placeholder Fields
    @objc dynamic var emailOrUsernameFieldPlaceholder: String?
    @objc dynamic var passwordFieldPlaceholder: String?
    
    // Accounts
    @objc dynamic var emailVerification = false
    @objc dynamic var isAllowedToEditProfile = false
    @objc dynamic var isAllowedToEditAvatar = false
    @objc dynamic var isAllowedToEditName = false
    @objc dynamic var isAllowedToEditUsername = false
    @objc dynamic var isAllowedToEditEmail = false
    @objc dynamic var isAllowedToEditPassword = false
    
    // Registration
    @objc dynamic var rawRegistrationForm: String?
    var registrationForm: RegistrationFormAccess {
        guard
            let rawValue = rawRegistrationForm,
            let value = RegistrationFormAccess(rawValue: rawValue)
            else {
                return .isPublic
        }
        return value
    }
    
    // File upload
    @objc dynamic var uploadStorageType: String?
    @objc dynamic var maxFileSize: Int = 0
    
    // Hide Message Types
    @objc dynamic var hideMessageUserJoined: Bool = false
    @objc dynamic var hideMessageUserLeft: Bool = false
    @objc dynamic var hideMessageUserAdded: Bool = false
    @objc dynamic var hideMessageUserMutedUnmuted: Bool = false
    @objc dynamic var hideMessageUserRemoved: Bool = false
    
    // Message
    @objc dynamic var messageGroupingPeriod = AuthSettingsDefaults.messageGroupingPeriod
    
    @objc dynamic var messageAllowPinning = true
    @objc dynamic var messageAllowStarring = true
    
    @objc dynamic var messageShowDeletedStatus: Bool = true
    @objc dynamic var messageAllowDeleting: Bool = true
    @objc dynamic var messageAllowDeletingBlockDeleteInMinutes: Int = 0
    
    @objc dynamic var messageShowEditedStatus: Bool = true
    @objc dynamic var messageAllowEditing: Bool = true
    @objc dynamic var messageAllowEditingBlockEditInMinutes: Int = 0
    
    @objc dynamic var messageMaxAllowedSize: Int = 0
    
    @objc dynamic var messageReadReceiptEnabled: Bool = false
    @objc dynamic var messageReadReceiptStoreUsers: Bool = false
    
    // Custom fields
    @objc dynamic var rawCustomFields: String?
}
