//
//  HTTPMethod.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/19/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
    case delete = "DELETE"
    case patch = "PATCH"
    case trace = "TRACE"
    case options = "OPTIONS"
    case connect = "CONNECT"
}
