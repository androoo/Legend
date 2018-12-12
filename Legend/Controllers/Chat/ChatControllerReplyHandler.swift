//
//  ChatControllerReplyHandler.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 12/3/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit
//import SlackTextViewController

extension ChatViewController {
    func setupReplyView() {
        replyView = ReplyView.instantiateFromNib()
//        replyView.frame = textInputbar.addonContentView.bounds
        replyView.frame = messageView.textView.bounds
        replyView.onClose = { [weak self] in
            self?.stopReplying()
        }
        
        textInputbar.addonContentView.addSubview(replyView)
    }
    
    func reply(to message: Message, onlyQuote: Bool = false) {
        replyView.alpha = 0
        replyView.username.text = message.user?.username
        replyView.message.text = message.text
        
        UIView.animate(withDuration: 0.25, animations: {
            self.textInputbar.addonContentViewHeight = 50
            self.textInputbar.layoutIfNeeded()
            self.replyView.frame = self.textInputbar.addonContentView.bounds
            self.textDidUpdate(false)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.25) {
                self.replyView.alpha = 1
            }
        })
        
        textView.becomeFirstResponder()
        
        replyString = (onlyQuote ? message.quoteString : message.replyString) ?? ""
        
        scrollToBottom()
    }
    
    func clearReplying() {
        replyView.alpha = 0
        replyString = ""
    }
    
    func stopReplying() {
        replyView.alpha = 1
        
        UIView.animate(withDuration: 0.25, animations: ({
            self.replyView.alpha = 0
        }), completion: ({ _ in
            UIView.animate(withDuration: 0.25) {
                self.textInputbar.addonContentViewHeight = 0
                self.textInputbar.layoutIfNeeded()
                self.replyView.frame = self.textInputbar.addonContentView.bounds
                self.textDidUpdate(false)
            }
        }))
        
        clearReplying()
    }
    
}
