//
//  UINavigationBarTransparent.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/14/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
    
    func setNonTransparent() {
        let navigationBar = UINavigationBar(frame: frame)
        setBackgroundImage(navigationBar.backIndicatorImage, for: .default)
        shadowImage = navigationBar.shadowImage
        isTranslucent = false
    }
}
