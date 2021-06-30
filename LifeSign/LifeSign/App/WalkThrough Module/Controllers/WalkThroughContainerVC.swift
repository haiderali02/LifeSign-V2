//
//  WalkThroughContainerVC.swift
//  LifeSign
//
//  Created by Haider Ali on 15/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class WalkThroughContainerVC: UIPageViewController {

    lazy var subViewControllers: [UIViewController] = {
        return [
            R.storyboard.walkThrough.okSignInfoVC() ?? UIViewController(),
            R.storyboard.walkThrough.sosInfoVC() ?? UIViewController(),
            R.storyboard.walkThrough.dailySignInfoVC() ?? UIViewController(),
            R.storyboard.walkThrough.friendInfoVC() ?? UIViewController(),
            R.storyboard.walkThrough.gameInfoVC() ?? UIViewController()
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
    }

    func setViewContollerAtIndex (index: Int, animate: Bool = true) {
        setViewControllers([subViewControllers[index]], direction: .forward, animated: animate, completion: nil)
    }
}

extension WalkThroughContainerVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
