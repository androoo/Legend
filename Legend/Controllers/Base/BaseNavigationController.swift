//
//  BaseNavigationController.swift
//  Legend
//
//  Created by Andrew Ervin Gierke on 11/14/18.
//  Copyright © 2018 And. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: BaseNavigationBar.self, toolbarClass: nil)
        self.setViewControllers([rootViewController], animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        (viewController as? BaseViewControler)?.willBePushed(animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: animated)
        (viewController as? BaseViewControler)?.willBePopped(animated: animated)
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navBar = self.navigationBar
        navBar.isTranslucent = false
        (navBar as? BaseNavigationBar)?.themeSource = self
        view.backgroundColor = .white
        ThemeManager.addObserver(self)
    }
}

extension BaseNavigationController: BaseNavigationBarThemeSource {
    var navigationBarTheme: Theme? {
        return topViewController?.view.theme
    }
}

//MARK: - Themable

extension BaseNavigationController {
    override func applyTheme() {
        super.applyTheme()
        view.backgroundColor = navigationBar.theme?.backgroundColor ?? .white
    }
}
