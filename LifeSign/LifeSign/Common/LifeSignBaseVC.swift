//
//  LifeSignBaseVCViewController.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import MaterialComponents
import SnapKit
import UIKit
import MessageKit

class LifeSignBaseVC: UIViewController {

    
    var popRecognizer: InteractivePopRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        implementSwipeToPop()
        setInteractiveRecognizer()
    }
    func push(controller: UIViewController, animated: Bool) {
        navigationController?.pushViewController(controller, animated: animated)
    }
    @objc func pop(controller: UIViewController, animation: Bool = true) {
        controller.navigationController?.popViewController(animated: animation)
    }
    private func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    @objc func popToDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func implementSwipeToPop() {
        
        let gestureRec = UISwipeGestureRecognizer(target: self, action: #selector(popToDismiss))
        gestureRec.direction = .right
        self.view.addGestureRecognizer(gestureRec)
        
    }
    
}

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
        let ai = UIActivityIndicatorView(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    
    func showSkeleton() {
        view.showAnimatedSkeleton()
    }
    
    func hideSkeleton() {
        view.hideSkeleton(transition: .crossDissolve(1))
    }
    
}

