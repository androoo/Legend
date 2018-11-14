//
//  BaseViewController.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/14/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

class BaseViewControler: UIViewController {
    var isNavigationBarTransparent: Bool {
        return false
    }
    
    func updateNavigationBarTransparency() {
        if isNavigationBarTransparent {
            navigationController?.navigationBar.setTransparent()
        } else {
            navigationController?.navigationBar.setNonTransparent()
        }
        navigationController?.redrawNavigationBar()
    }
    
    func willBePushed(animated: Bool) {
        updateNavigationBarTransparency()
    }
    
    func willBePopped(animated: Bool) {
        if let controller = navigationController?.topViewController as? BaseViewControler {
            controller.updateNavigationBarTransparency()
        } else {
            navigationController?.navigationBar.setNonTransparent()
            navigationController?.redrawNavigationBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.addObserver(self)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let screenName = String(describing: type(of: self))
        Analyticsmanager.log(event: .screenView(screenName: screenName))
    }
    
    override func applyTheme() {
        super.applyTheme()
        updateNavigationBarTransparency()
    }
}
