//
//  TransparentToTouchesWindow.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

class TransparentToTouchesWindow: UIWindow {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let rootViewController = self.rootViewController {
            for subview in rootViewController.view.subviews {
                if subview.frame.contains(point) {
                    return super.hitTest(point, with: event)
                }
            }
        }
        return nil
    }
}
