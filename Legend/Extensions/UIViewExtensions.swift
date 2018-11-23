//
//  UIViewExtensions.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
    
    static func instantiateFromNib() -> Self? {
        func instanceFromNib<T: UIView>() -> T? {
            return nib.instantiate() as? T
        }
        return instanceFromNib()
    }
}
