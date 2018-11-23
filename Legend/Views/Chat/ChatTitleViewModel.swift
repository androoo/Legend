//
//  ChatTitleViewModel.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import UIKit

final class ChatTitleViewModel {
    
    internal var user: User?
    var subscription: Subscription? {
        didSet {
            guard let subscription = subscription,
                !subscription.isInvalidated else {
                    return
            }
            user = subscription.directMessageUser
        }
    }
    
    var title: String {
        return subscription?.displayName() ?? ""
    }
    
    var iconColor: UIColor {
        guard let user = user else { return .LGGray() }
        
        switch user.status {
        case .online: return .LGGray()
        case .offline: return .LGGray()
        case .away: return .LGFavoriteUnmark()
        case .busy: return .LGLightBlue()
        }
    }
    
    var imageName: String {
        guard let subscription = subscription else {
            return "Channel Small"
        }
        
        switch subscription.type {
        case .channel: return "Channel Small"
        case .directMessage: return "DM Small"
        case .group: return "Group Small"
        }
    }
    
}


