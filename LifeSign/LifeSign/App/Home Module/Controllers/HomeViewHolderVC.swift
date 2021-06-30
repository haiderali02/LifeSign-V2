//
//  HomeViewHolderVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class HomeViewHolderVC: UIPageViewController {

   let sosController = R.storyboard.soS.sosvC() ?? SOSVC()
   let friendController = R.storyboard.friends.friendsVC() ?? FriendsVC()
   let lifeSignController = R.storyboard.lifeSign.lifeSignVC() ?? LifeSignVC()
   let gameController = R.storyboard.game.gameVC() ?? GameVC()
   let shopController = R.storyboard.shop.shopVC() ?? ShopVC()
    
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            sosController,
            friendController,
            lifeSignController,
            gameController,
            shopController
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    private func setupView () {
        self.delegate = self
        self.dataSource = self
        setViewContollerAtIndex(index: 0)
        self.isPagingEnabled = false
    }

    func setViewContollerAtIndex (index: Int, animate: Bool = true) {
        setViewControllers([subViewControllers[index]], direction: .forward, animated: animate, completion: nil)
    }
}

extension HomeViewHolderVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentIndex = subViewControllers.firstIndex(of: viewController) {
            if currentIndex <= 0 {
                return nil
            } else {
                return subViewControllers[currentIndex - 1]
            }
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = subViewControllers.firstIndex(of: viewController) {
            if currentIndex >= (subViewControllers.count - 1) {
                return nil
            } else {
                return subViewControllers[currentIndex + 1]
            }
        } else {
            return nil
        }
    }
}
