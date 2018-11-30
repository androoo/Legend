//
//  Closeable.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/30/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

protocol Closeable {
    func close(animated: Bool)
}

extension Closeable where Self: UIViewController {
    func close(animated: Bool) {
        if navigationController?.topViewController == self {
            navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
}
