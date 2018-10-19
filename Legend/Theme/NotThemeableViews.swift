//
//  NotThemeableViews.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 10/18/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

class NotThemeableView: UIView {
    override var theme: Theme? { return nil }
}

class NotThemeableViewController: UITableView {
    override var theme: Theme? { return nil }
}

class NotThemeableNavigationBar: UINavigationBar {
    override var theme: Theme? { return nil }
}

class NotThemeableLabel: UILabel {
    override var theme: Theme? { return nil }
}
