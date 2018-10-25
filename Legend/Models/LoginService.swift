//
//  LoginService.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/25/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift

enum LoginServiceType {
    case saml
    case cas
    case custom
    case invalid
    
    init(string: String) {
        switch string {
        case "saml": self = .saml
        case "case": self = .cas
        default: self = .invalid
        }
    }
}

class LoginService: BaseModel {
    @objc dynamic var service: String?
    @objc dynamic var clientId: String?
    @objc dynamic var custom = false
    @objc dynamic var serverUrl: String?
    @objc dynamic var tokenPath: String?
    @objc dynamic var authorizePath: String?
    @objc dynamic var scope: String?
    @objc dynamic var buttonLabelText: String?
    @objc dynamic var buttonLabelColor: String?
    @objc dynamic var tokenSentVia: String?
    @objc dynamic var usernameField: String?
    @objc dynamic var mergeUsers = false
    @objc dynamic var loginStyle: String?
    @objc dynamic var buttonColor: String?
    
    // CAS
    
    @objc dynamic var loginUrl: String?
    
    // SAML
    
    @objc dynamic var entryPoint: String?
    @objc dynamic var issuer: String?
    @objc dynamic var provider: String?
    
    // true if LoginService has enough info to be used
    var isValid: Bool {
        if type == .cas && loginURL != nil {
            return true
        }
        
        if type == .saml {
            return true
        }
        
        return !(serverUrl?.isEmpty ?? true)
    }
    
    var type: LoginServiceType {
        if custom == true {
            return .custom
        }
        
        if let service = service {
            return LoginServiceType(string: service)
        }
        
        return .invalid
    }
    
    @objc dynamic var callbackPath: String?
    
}

// MARK: OAuth helper extensions

extension LoginService {
    var authorizeUrl: String? {
        guard
            let serverUrl = serverUrl,
            let authorizePath = authorizePath
            else {
                return nil
        }
        
        return "\(serverUrl)\(authorizePath)"
    }
    
    var accessTokenUrl: String? {
        guard
            let serverUrl = serverUrl,
            let tokenPath = tokenPath
            else {
                return nil
        }
        
        return tokenPath.contains("://") ? tokenPath : "\(serverUrl)\(tokenPath)"
    }
}

// MARK: Realm extensions

extension LoginService {
    static func find(service: String, realm: Realm) -> LoginService? {
        var object: LoginService?
        
        if let findObject = realm.objects(LoginService.self).filter("service == '\(service)'").first {
            object = findObject
        }
        
        return object
    }
}
