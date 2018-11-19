//
//  BaseTableViewController.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/14/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ThemeManager.addObserver(self)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenName = String(describing: type(of: self))
//        AnalyticsManager.log(event: .screenView(screenName: screenName))
    }
}
