//
//  AuthExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

extension Auth {
    func baseURL() -> String? {
        if let cdn = self.settings?.cdnPrefixURL {
            if cdn.count > 0 {
                return cdn
            }
        }
        return self.settings?.siteURL
    }
}
