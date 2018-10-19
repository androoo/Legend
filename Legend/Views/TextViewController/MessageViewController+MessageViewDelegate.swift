//
//  MessageViewController+MessageViewDelegate.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 7/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension MessageViewController: MessageViewDelegate {

    internal func sizeDidChange(messageView: MessageView) {
        UIView.animate(withDuration: 0.25) {
            self.layout()
        }
    }

    internal func wantsLayout(messageView: MessageView) {
        view.setNeedsLayout()
    }

    internal func selectionDidChange(messageView: MessageView) {}

}
