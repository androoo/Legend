//
//  LoginServiceModelMapping.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/27/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

extension LoginService: ModelMappeable {
    func map(_ values: JSON, realm: Realm?) {
        if identifier == nil {
            identifier = values["_id"].string ?? values["id"].string
        }
        
        service = values["name"].string ?? values["service"].string
        clientId = values["appId"].string ?? values["clientId"].string
        custom = values["custom"].boolValue
        serverUrl = values["serverURL"].stringValue
        tokenPath = values["tokenPath"].stringValue
        authorizePath = values["authorizePath"].stringValue
        scope = values["scope"].stringValue
        buttonLabelText = values["buttonLabelText"].stringValue
        buttonLabelColor = values["buttonLabelColor"].stringValue
        tokenSentVia = values["tokenSentVia"].stringValue
        usernameField = values["usernameField"].stringValue
        mergeUsers = values["mergeUsers"].boolValue
        loginStyle = values["loginStyle"].string
        buttonColor = values["buttonColor"].string
        
        // CAS
        loginUrl = values["login_url"].string
        
        // SAML
        entryPoint = values["entryPoint"].string
        issuer = values["issuer"].string
        provider = values["clientConfig"]["provider"].string
        
        switch type {
            // add SSO services here if added later 
        case .custom: break
        case .saml: break
        case .cas: break
        case .invalid: break
        }
    }
    
    func mapCAS() {
        service = "cas"
        
        buttonLabelText = "CAS"
        buttonLabelColor = "#ffffff"
        buttonColor = "#13679a"
    }
}
