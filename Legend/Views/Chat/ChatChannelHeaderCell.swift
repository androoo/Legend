//
//  ChatChannelHeaderCell.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 8/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

final class ChatChannelHeaderCell: UICollectionViewCell {
    static let minimumHeight = CGFloat(200)
    static let identifier = "ChatChannelHeaderCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startConversationLabel: UILabel!
    
    var subscription: Subscription? {
        didSet {
            titleLabel.text = subscription?.displayName()
            let startText = localized("chat.channel.start_conversation")
            startConversationLabel.text = String(format: startText, subscription?.displayName() ?? "")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        startConversationLabel.text = ""
    }
}
