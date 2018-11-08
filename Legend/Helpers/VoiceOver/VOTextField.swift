//
//  VOTextField.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

class VOTextField: UITextField {
    override var accessibilityLabel: String? {
        get { return localizedAccessibilityLabel }
        set { }
    }
    
    override var accessibilityHint: String? {
        get { return localizedAccessibilityHint }
        set { }
    }
}
