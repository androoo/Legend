//
//  UIScrollView+StopScrolling.swift
//  Something
//
//  Created by Andrew Ervin Gierke on 7/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

extension UIScrollView {

    func stopScrolling() {
        guard isDragging else { return }

        var offset = contentOffset
        offset.y -= 1
        self.setContentOffset(offset, animated: false)
        offset.y += 1
        self.setContentOffset(offset, animated: false)
    }

}
