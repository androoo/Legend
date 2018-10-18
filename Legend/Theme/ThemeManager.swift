//
//  ThemeManager.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation
import UIKit

struct ThemeManager {
    
    /**
     Stores a default 'Theme' for the app.
     
     Setting a new value will cause the 'applyTheme' method to be called on all the `ThemeManager.observers`. The transition is animated by default.
     */
    
    static var theme = themes.first(where: { $0.title == UserDefaults.standard.string(forKey: userDefaultsKey) })?.theme ?? Theme.light {
        didSet {
            UIView.animate(withDuration: 0.3) {
                observers.forEach { $0.value?.applyTheme() }
            }
            let themeName = themes.first(where: {$0.theme == theme} )?.title
            UserDefaults.standard.set(themeName, forKey: userDefaultsKey)
        }
    }
    
    static let userDefaultsKey = "LGTheme"
    static let themes: [(title: String, theme: Theme)] = [("light", .light), ("dark", .dark), ("black", .black)]
    
    static var observers = [Weak<Themable>]()
    
    /**
     Allows for 'applyTheme' to be called automatically on the `observer` when the `ThemeManager.theme` changes.
     
     ThemeManager holds a weak reference to the 'observer'
     */
    
    static func addObserver(_ observer: Themable?) {
        observers = observers.compactMap { $0 }
        guard let observer = observer else { return }
        observer.applyTheme()
        observers.append(Weak(observer))
    }
}

fileprivate extension Array where Element == Weak<AnyObject> {
    mutating func filterReleasedReferences() {
        self = self.compactMap { $0 }
    }
}

