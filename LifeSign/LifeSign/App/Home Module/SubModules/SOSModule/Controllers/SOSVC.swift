//
//  SOSVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class SOSVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var sosFriendsCounter: UIButton!
    
    @IBOutlet weak var sosListingCounter: UIButton!
    @IBOutlet weak var sosSegmentBar: UISegmentedControl! {
        didSet {
            let unSelectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appYellowColor]
            let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appBoxColor]
            sosSegmentBar.setTitleTextAttributes(unSelectedAttribute, for: .normal)
            sosSegmentBar.setTitleTextAttributes(selectedAttribute, for: .selected)
            sosSegmentBar.selectedSegmentTintColor = UIColor.appYellowColor
        }
    }
    
    // MARK:- PROPERTIES -
    
    var sosTabs: SOSContainerVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observerLanguageChange()
        setupUI()
        setText()
    }
    
    @objc func setText() {
       
        sosSegmentBar.setTitle(AppStrings.getSOSTitle(), forSegmentAt: 0)
        sosSegmentBar.setTitle(AppStrings.getFriendsString(), forSegmentAt: 1)
        sosSegmentBar.setTitle(AppStrings.getSOSListingTitle(), forSegmentAt: 2)
    }
    
    @objc func openFriends() {
       
        sosSegmentBar.setTitle(AppStrings.getSOSTitle(), forSegmentAt: 0)
        sosSegmentBar.setTitle(AppStrings.getFriendsString(), forSegmentAt: 1)
        sosSegmentBar.setTitle(AppStrings.getSOSListingTitle(), forSegmentAt: 2)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCounters), name: .reloadNotificationView, object: nil)
    }
    
    private func setupUI() {
        guard let sosTabs = self.children.first as? SOSContainerVC else {return}
        self.sosTabs = sosTabs
        
        sosTabs.setSelectedTab = { (index, value) in
            self.sosSegmentBar.selectedSegmentIndex = index
        }
        updateCounters()
    }
    
    @objc func updateCounters() {
        let sosFriendBadgeValue = UserCounters.shared.sos_friend > 0 ? "\(UserCounters.shared.sos_friend)" : ""
        self.sosFriendsCounter.setTitle(sosFriendBadgeValue, for: .normal)
        
        let sosListingBadgeValue = UserCounters.shared.sos_listing > 0 ? "\(UserCounters.shared.sos_listing)" : ""
        self.sosListingCounter.setTitle(sosListingBadgeValue, for: .normal)
    
        if sosFriendBadgeValue == "" {
            self.sosFriendsCounter.isHidden = true
        } else {
            self.sosFriendsCounter.isHidden = false
        }
        if sosListingBadgeValue == "" {
            self.sosListingCounter.isHidden = true
        } else {
            self.sosListingCounter.isHidden = false
        }
        
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didChangeSOSTabs(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.handleSOS()
        case 1:
            self.handleSOSFriends()
        case 2:
            self.handleSOSListing()
        default:
            return
        }
    }
}

extension SOSVC {
    func handleSOS() {
        sosTabs.setViewContollerAtIndex(index: 0, animate: false)
        SocketHelper.shared.emitNotificationEventToSocket()
    }
    func handleSOSFriends() {
        sosTabs.setViewContollerAtIndex(index: 1, animate: false)
        SocketHelper.shared.emitNotificationEventToSocket()
    }
    func handleSOSListing() {
        sosTabs.setViewContollerAtIndex(index: 2, animate: false)
        SocketHelper.shared.emitNotificationEventToSocket()
    }
}
