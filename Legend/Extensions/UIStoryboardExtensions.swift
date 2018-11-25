//
//  UIStoryboardExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func controller(from storyboardName: String, identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
