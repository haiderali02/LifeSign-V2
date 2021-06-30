//
//  SOSContainerVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SYBadgeButton



class SOSContainerVC: UIPageViewController {

    lazy var subViewControllers: [UIViewController] = {
        return [
            R.storyboard.soS.sosSndRcvVC() ?? UIViewController(), // SOS Main Controller
            R.storyboard.soS.sosFriendVC() ?? UIViewController(), // SOS Friend VC
            R.storyboard.soS.sosListingVC() ?? UIViewController(), // LifeSign Controller
        ]
    }()
    
    var setSelectedTab: ((_ index: Int, _ value: Any?) -> Void)?
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return subViewControllers.firstIndex(of: vc) ?? 0
    }
    
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
        self.isPagingEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(setFreindTab), name: .openSOSFriends, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSOSListing), name: .openSOSListing, object: nil)
    }
    @objc func setFreindTab() {
        setViewContollerAtIndex(index: 1)
        self.setSelectedTab?(1, nil)
    }
    @objc func openSOSListing() {
        setViewContollerAtIndex(index: 2)
        self.setSelectedTab?(2, nil)
        
    }
    
    func setViewContollerAtIndex (index: Int, animate: Bool = true) {
        setViewControllers([subViewControllers[index]], direction: .forward, animated: animate, completion: nil)
    }
}

extension SOSContainerVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            self.setSelectedTab?(self.currentIndex, nil)
        }
        
    }
}
