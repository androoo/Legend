//
//  UISplitViewControllerExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/25/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UISplitViewController {
    
    var primaryViewController: UIViewController? {
        return self.viewControllers.first
    }
    
    var detailViewController: UIViewController? {
        return self.viewControllers.count > 1 ? self.viewControllers[1] : nil
    }
}
