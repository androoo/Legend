//
//  NSAttributedString+ReplaceRange.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 7/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    func replacingCharacters(in range: NSRange, with attributedString: NSAttributedString) -> NSMutableAttributedString {
        let ns = NSMutableAttributedString(attributedString: self)
        ns.replaceCharacters(in: range, with: attributedString)
        return ns
    }
    
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        return NSAttributedString(attributedString: ns)
    }
}

