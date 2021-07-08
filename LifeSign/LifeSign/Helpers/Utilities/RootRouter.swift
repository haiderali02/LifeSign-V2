//
//  RootRouter.swift
//  LifeSign
//
//  Copyright © softwarealliance. All rights reserved.
//

import UIKit

class RootRouter {

    /** Replaces root view controller. You can specify the replacment animation type.
     If no animation type is specified, there is no animation */
    func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("No window in app")
        }
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.33, options: animationOptions, animations: {
            }, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }
    
    func loadMainAppStructure() {
        // Customize your app structure here
        if UserManager.shared.isLoggedIn() {
            let homeVC = R.storyboard.home.homeBaseNavigationVC() ?? HomeBaseNavigationVC()
            setRootViewController(controller: homeVC, animatedWithOptions: nil)
        } else {
            let walkThroughController = R.storyboard.walkThrough.walkThroughNavigationController() ?? UIViewController()
            setRootViewController(controller: walkThroughController, animatedWithOptions: nil)
        }
    }
    
    
    func open(viewController: UIViewController) {
        if UserManager.shared.isLoggedIn() {
            let homeVC = R.storyboard.home.homeBaseNavigationVC() ?? HomeBaseNavigationVC()
            setRootViewController(controller: homeVC, animatedWithOptions: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let window = UIApplication.shared.windows.first else {
                    fatalError("No window in app")
                }
                if let navCntrl = window.rootViewController as? UINavigationController {
                    navCntrl.pushViewController(viewController, animated: true)
                }
            }
        }
    }
}
