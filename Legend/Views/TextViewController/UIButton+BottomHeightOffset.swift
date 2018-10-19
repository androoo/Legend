//
//  UIButton+InternalSizeOffset.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 7/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

internal extension UIButton {

    // the bottom space between the containing UIView and the closest content view (label or image)
    // should call sizeToFit() sometime before using this method
    var bottomHeightOffset: CGFloat {
        let height = bounds.size.height

        // adjust the button so its content is aligned w/ the bottom of the text view
        let titleLabelMaxY: CGFloat
        if let titleBounds = titleLabel?.frame, titleBounds != .zero {
            titleLabelMaxY = titleBounds.maxY
        } else {
            titleLabelMaxY = height
        }

        let imageViewMaxY: CGFloat
        if let imageBounds = imageView?.frame, imageBounds != .zero {
            imageViewMaxY = imageBounds.maxY
        } else {
            imageViewMaxY = height
        }

        return max(height - titleLabelMaxY, height - imageViewMaxY)
    }

}
