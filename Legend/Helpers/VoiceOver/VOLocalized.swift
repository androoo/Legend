//
//  VOLocalized.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/7/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var localizedAccessibilityLabel: String? {
        guard let accessibilityIdentifier = accessibilityIdentifier else { return nil }
        return VOLocalizedString("\(accessibilityIdentifier).label")
    }
    
    var localizedAccessibilityValue: String? {
        guard let accessibilityIdentifier = accessibilityIdentifier else { return nil }
        return VOLocalizedString("\(accessibilityIdentifier).value")
    }
    
    var localizedAccessibilityHint: String? {
        guard let accessibilityIdentifier = accessibilityIdentifier else { return nil }
        return VOLocalizedString("\(accessibilityIdentifier).hint")
    }
}

func VOLocalizedString(_ key: String) -> String? {
    let string = NSLocalizedString(key, tableName: "VoiceOver", bundle: Bundle.main, value: "", comment: "")
    return string != "" ? string : nil
}
