//
//  MessageTextFontAttributes.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

struct MessageTextFontAttributes {
    static let defaultFontSize = CGFloat(15)
    
    static func defaultFontColor(for theme: Theme? = nil) -> UIColor {
        return theme?.controlText ?? ThemeManager.theme.controlText
    }
    
    static func systemFontColor(for theme: Theme? = ThemeManager.theme) -> UIColor {
        return theme?.auxiliaryText ?? ThemeManager.theme.auxiliaryText
    }
    
    static func failedFontColor(for theme: Theme? = ThemeManager.theme) -> UIColor {
        return theme?.auxiliaryText ?? ThemeManager.theme.auxiliaryText
    }
    
    static let defaultFont = UIFont.systemFont(ofSize: defaultFontSize)
    static let italicFont = UIFont.italicSystemFont(ofSize: defaultFontSize)
    static let boldFont = UIFont.boldSystemFont(ofSize: defaultFontSize)
}
