//
//  LGDateFormatter.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/24/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

final class LGDateFormatter {
    private static let dateFormatter = DateFormatter()
    
    static func date(_ date: Date, dateStyle: DateFormatter.Style = .medium) -> String {
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = .none
        return self.dateFormatter.string(from: date)
    }
    
    static func time(_ date: Date, timeStyle: DateFormatter.Style = .short) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = timeStyle
        return self.dateFormatter.string(from: date)
    }
    
    static func datetime(_ date: Date, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short) -> String {
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return self.dateFormatter.string(from: date)
    }
}
