//
//  ThemeableViewControllers.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UIViewController: Themeable {
    
    /**
     Calls the `applyTheme` on the `view` and the `navigationController`.
     
     - Important:
     On first initializaiton, it is recommended that the view controller be added as an observer to the ThemeManager using the `ThemeManager.addObserver(_:)` method.
     */
    
    func applyTheme() {
        view.applyTheme()
        navigationController?.navigationBar.applyTheme()
    }
}
