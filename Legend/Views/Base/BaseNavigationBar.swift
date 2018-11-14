//
//  BaseNavigationBar.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/14/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

protocol BaseNavigationBarThemeSource: class {
    var navigationBarTheme: Theme? { get }
}

class BaseNavigationBar: UINavigationBar {
    weak var themeSource: BaseNavigationBarThemeSource?
    override var theme: Theme? {
        return themeSource?.navigationBarTheme
    }
}
