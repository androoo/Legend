//
//  APIResponse.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/19/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

enum APIResponse<T: APIResource> {
    case resource(T)
    case error(APIError)
}
