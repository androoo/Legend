//
//  MessageViewDelegate.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 7/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

internal protocol MessageViewDelegate: class {
    func sizeDidChange(messageView: MessageView)
    func wantsLayout(messageView: MessageView)
    func selectionDidChange(messageView: MessageView)
}
