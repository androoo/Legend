//
//  CommandsRequest.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import SwiftyJSON

struct CommandsRequest: APIRequest {
    typealias APIResourceType = CommandsResource
    let path = "/api/v1/commands.list"
    let requiredVersion = Version(0, 60, 0)
}

final class CommandsResource: APIResource {
    var commands: [Command]? {
        return raw?["commands"].arrayValue.map {
            let command = Command()
            command.map($0, realm: nil)
            return command
            }.compactMap { $0 }
    }
}
