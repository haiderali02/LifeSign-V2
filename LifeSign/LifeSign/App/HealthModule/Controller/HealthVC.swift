//
//  HealthVC.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class HealthVC: LifeSignBaseVC {
    
    //MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton!{
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var myHealthView: UIView!
    @IBOutlet weak var myHealthBottomView: UIView!
    @IBOutlet weak var myHealthBtn: UIButton!{
        didSet{
            myHealthBtn.tintColor = .clear
            myHealthBtn.setTitleColor(R.color.appYellowColor(), for: .normal)
            myHealthBtn.setTitleColor(R.color.appGreenColor(), for: .selected)
        }
    }
    @IBOutlet weak var friendsHealthView: UIView!
    @IBOutlet weak var friendsHealthBottomView: UIView!
    @IBOutlet weak var friendsHealthBtn: UIButton!{
        didSet{
            friendsHealthBtn.tintColor = .clear
            friendsHealthBtn.setTitleColor(R.color.appYellowColor(), for: .normal)
            friendsHealthBtn.setTitleColor(R.color.appGreenColor(), for: .selected)
        }
    }
    @IBOutlet weak var friendRequestView: UIView!
    @IBOutlet weak var friendRequestBottomView: UIView!
    @IBOutlet weak var friendRequestBtn: UIButton!{
        didSet{
            friendRequestBtn.tintColor = .clear
            friendRequestBtn.setTitleColor(R.color.appYellowColor(), for: .normal)
            friendRequestBtn.setTitleColor(R.color.appGreenColor(), for: .selected)
        }
    }
    
    //MARK:- PROPERTIES -
    var healthTabs: HealthContainerVC?
    
    //MARK:- LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        myHealthBtn.isSelected = true
        myHealthBottomView.isHidden = false
        friendsHealthBottomView.isHidden = true
        friendRequestBottomView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //MARK:- METHODS -
    @objc func setText(){
        
    }
    
    func setUI() {
        guard let healthTabs = self.children.first as? HealthContainerVC else {return}
        self.healthTabs = healthTabs
        
        healthTabs.setSelectedTab = { (index, value) in
            
            print("Index: \(index)")
        }
        
        myHealthBtn.titleLabel?.font = Constants.headerTitleFont
        friendsHealthBtn.titleLabel?.font = Constants.headerTitleFont
        friendRequestBtn.titleLabel?.font = Constants.headerTitleFont
        
        //updateCounters()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    //MARK:- ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddFriendBtn(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
    
    fileprivate func updateHeaderButtons(_ tag: Int) {
        if tag == 0{
            //My Health Selected...
            myHealthBtn.isSelected = true
            myHealthBottomView.isHidden = false
            friendsHealthBtn.isSelected = false
            friendsHealthBottomView.isHidden = true
            friendRequestBtn.isSelected = false
            friendRequestBottomView.isHidden = true
            self.myHealth()
            
        }else if tag == 1{
            //Friends Health Selected...
            myHealthBtn.isSelected = false
            myHealthBottomView.isHidden = true
            friendsHealthBtn.isSelected = true
            friendsHealthBottomView.isHidden = false
            friendRequestBtn.isSelected = false
            friendRequestBottomView.isHidden = true
            self.FriendsHealth()
            
        }else{
            //Friends Request Selected...
            myHealthBtn.isSelected = false
            myHealthBottomView.isHidden = true
            friendsHealthBtn.isSelected = false
            friendsHealthBottomView.isHidden = true
            friendRequestBtn.isSelected = true
            friendRequestBottomView.isHidden = false
            self.FriendsRequest()
        }
    }
    
    @IBAction func didTapHealthBtn(_ sender: UIButton) {
        
        updateHeaderButtons(sender.tag)
    
        
    }
    
    
}

extension HealthVC {
    func myHealth() {
        healthTabs!.setViewContollerAtIndex(index: 0, animate: false)
        //SocketHelper.shared.emitNotificationEventToSocket()
    }
    func FriendsHealth() {
        healthTabs!.setViewContollerAtIndex(index: 1, animate: false)
        //SocketHelper.shared.emitNotificationEventToSocket()
    }
    func FriendsRequest() {
        healthTabs!.setViewContollerAtIndex(index: 2, animate: false)
        //SocketHelper.shared.emitNotificationEventToSocket()
    }
}
