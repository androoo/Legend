//
//  AppDelegate.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 9/20/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var notificationWindow: TransparentToTouchesWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        Launcher().prepareToLaunch(with: launchOptions)
        
        return true 
    }


}

