//
//  UIColorExtension.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 9/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

enum SystemMessageColor {
    case warning
    case danger
    case good
    case unknown(String)
    
    init(rawValue: String) {
        switch rawValue {
        case SystemMessageColor.warning.rawValue: self = .warning
        case SystemMessageColor.danger.rawValue: self = .danger
        case SystemMessageColor.good.rawValue: self = .good
        default:
            self = .unknown(rawValue)
        }
    }
    
    var rawValue: String {
        return String(describing: self)
    }
    
    var color: UIColor {
        switch self {
        case .warning: return UIColor(rgb: 0xFCB316, alphaValue: 1)
        case .danger: return UIColor(rgb: 0xD30230, alphaValue: 1)
        case .good: return UIColor(rgb: 0x35AC19, alphaValue: 1)
        case .unknown(let string): return UIColor(hex: string)
        }
    }
}

extension UIColor {
    
    convenience init(rgb: Int, alphaValue: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alphaValue)
        )
    }
}
