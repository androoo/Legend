//
//  APIClient.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/19/18.
//  Copyright © 2018 And. All rights reserved.
//

extension API {
    func client<C: APIClient>(_ type: C.Type) -> C {
        return C(api: self)
    }
}

protocol APIClient {
    var api: AnyAPIFetcher { get }
    init(api: AnyAPIFetcher)
}
