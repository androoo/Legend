//
//  MessageURL.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/17/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

final class MessageURL: Object {
    @objc dynamic var textDescription: String?
    @objc dynamic var title: String?
    @objc dynamic var targetURL: String?
    @objc dynamic var imageURL: String?
    
    func isValid() -> Bool {
        guard
            let titleCount = title?.count,
            let descriptionCount = textDescription?.count
        else {
            return false
        }
        
        return titleCount > 0 && descriptionCount > 0
    }
}
