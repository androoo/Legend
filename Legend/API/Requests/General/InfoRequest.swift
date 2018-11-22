//
//  InfoRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/21/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

final class InfoRequest: APIRequest {
    typealias APIResourceType = InfoResource
    
    let path = "/api/v1/info"
}

final class InfoResource: APIResource {
    var version: String? {
        return raw?["info"]["version"].string 
    }
}
