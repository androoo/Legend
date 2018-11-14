//
//  UINavigationControllerRedrawBar.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/14/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UINavigationController {
    func redrawNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false 
    }
}
