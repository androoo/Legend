//
//  LauncherProtocol.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

protocol LauncherProtocol {
    func prepareToLaunch(with options: [UIApplicationLaunchOptionsKey: Any]?)
}

final class Launcher: LauncherProtocol {
    private lazy var launchers: [LauncherProtocol] = {
        return [
            
        ]
    }()
    
    func prepareToLaunch(with options: [UIApplicationLaunchOptionsKey : Any]?) {
        launchers.forEach { $0.prepareToLaunch(with: options) }
    }
}
