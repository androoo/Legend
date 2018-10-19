//
//  UISearchBarTextField.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UISearchBar {
    var textField: UITextField? {
        return value(forKey: "_searchField") as? UITextField
    }
}
