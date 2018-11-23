//
//  ChatCollectionViewFlowLayout.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/23/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

final class ChatCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var heightOfInsertedItems: CGFloat = 0.0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let transform = CGAffineTransform(translationX: 0, y: heightOfInsertedItems)
        let offset = proposedContentOffset.applying(transform)
        heightOfInsertedItems = 0.0
        return offset
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        heightOfInsertedItems = updateItems.reduce(CGFloat(0.0)) { result, item in
            guard
                item.updateAction == .insert,
                let index = item.indexPathAfterUpdate,
                let attrs = layoutAttributesForItem(at: index)
                else {
                    return result
            }
            
            return result + attrs.frame.height
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
    }
    
    override func finalizeCollectionViewUpdates() {
        CATransaction.commit()
    }
    
}

