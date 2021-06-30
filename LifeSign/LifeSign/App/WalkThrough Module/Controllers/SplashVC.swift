//
//  SplashVC.swift
//  LifeSign
//
//  Created by Haider Ali on 10/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//
import RevealingSplashView
import UIKit

class SplashVC: LifeSignBaseVC {

    // MARK: - Outlets -

    @IBOutlet weak private var appLogo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        perFormSplashAnimation()
        
        
        
        // Do any additional setup after loading the view.
    }

    // MARK: - METHODS -

    func perFormSplashAnimation() {
        guard let logo = R.image.appLogo() else {
            return
        }
        let size = appLogo.frame.size
        let splashView = RevealingSplashView(iconImage: logo, iconInitialSize: size, backgroundColor: .clear)
        splashView.animationType = .heartBeat
        splashView.duration = 5.0
        view.addSubview(splashView)
        splashView.heartAttack = true
        splashView.startAnimation {
            self.navigateBasedOnLoginState(isLoggedIn: false) // replace when user obj implemented
        }
    }
    func navigateBasedOnLoginState(isLoggedIn: Bool) {
        isLoggedIn ? navigateToDashboard() : navigateToWalkThrough()
    }
    func navigateToWalkThrough() {
        guard let controller = R.storyboard.walkThrough.walkThroughVC() else {
            fatalError("Unable to find WalkThrough Controller")
        }
        push(controller: controller, animated: false)
    }
    func navigateToDashboard() {
    }
}
