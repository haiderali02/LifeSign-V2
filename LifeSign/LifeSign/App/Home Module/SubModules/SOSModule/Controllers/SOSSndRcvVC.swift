//
//  SOSSndRcvVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import PopBounceButton
import AVFoundation
import SwiftySound

class SOSSndRcvVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var sosTitleLabe: UILabel! {
        didSet {
            sosTitleLabe.font = Constants.autHeadingFont
        }
    }
    @IBOutlet weak var sosSubTitleLabel: UILabel! {
        didSet {
            sosSubTitleLabel.font = Constants.headerSubTitleFont
        }
    }
    
    @IBOutlet weak var resetButton: DesignableButton! {
        didSet {
            resetButton.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var sendSOSButton: UIButton!
    
    var timer: Timer?
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func setupUI() {
        addLongPressGesture()
        resetButton.isHidden = true
        sendSOSButton.tintColor = .systemRed
        sendSOSButton.setBackgroundImage(R.image.ic_sos_sent(), for: .disabled)
        sendSOSButton.setBackgroundImage(R.image.ic_sos_normal(), for: .normal)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    private var generalEvent = "App_Events_CounterEvent:5"
    
    @objc func setText() {
        sendSOSButton.setTitle(AppStrings.getPushForThreeSecString(), for: .normal)
        resetButton.setTitle(AppStrings.getResetString(), for: .normal)
        sosTitleLabe.text = AppStrings.getSOSPageTitle()
        sosSubTitleLabel.text = AppStrings.getSOSPageSubTitle()
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            
            guard let userSOSFriends = UserManager.shared.userFriends?.sos_friends else {return}
            if !(userSOSFriends > 0) {
                noSOSFriendFoundAlert()
                return
            }
            
            SOSManager.sendSOS { (status, displayPopup, message, errors) in
                if errors == nil {
                    if displayPopup != nil {
                        // Show SMS Runout Alert
                        self.showBuySMSAlert(message ?? "")
                    }
                    Sound.play(file: .sosSent)
                    self.sendSOSButton.resignFirstResponder()
                    self.sendSOSButton.setTitle(AppStrings.sosSents(), for: .normal)
                    self.sendSOSButton.isEnabled = false
                    self.startTimerAndResetButton()
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
    }
    
    
    func startTimerAndResetButton() {
        self.resetButton.isHidden = false
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { (time) in
            self.sendSOSButton.isEnabled = true
            self.resetButton.isHidden = true
            self.sendSOSButton.setTitle(AppStrings.getPushForThreeSecString(), for: .normal)
            self.timer?.invalidate()
        }
    }
    
    
    func showBuySMSAlert(_ message: String) {
        let alertController = UIAlertController(title: AppStrings.getAlertString(), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Simply Dismiss
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getBuySMSString(), style: .default, handler: { (_ ) in
            // Redirect To Shop To Buy SMS
            NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex": 2])
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addLongPressGesture(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 2.0
        self.sendSOSButton.addGestureRecognizer(longPress)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapReset(_ sender: DesignableButton) {
        resetButton.isHidden = true
        self.sendSOSButton.isEnabled = true
        self.sendSOSButton.setTitle(AppStrings.getPushForThreeSecString(), for: .normal)
        self.timer?.invalidate()
    }
    fileprivate func noSOSFriendFoundAlert() {
        let alertController = UIAlertController(title: AppStrings.getAlertString(), message: AppStrings.getNoFriendInSOS(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Simply Dismiss
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getGotoFriends(), style: .default, handler: { (_ ) in
            NotificationCenter.default.post(name: .redirectToFriends, object: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSendSOS(_ sender: UIButton) {
        // Handled In Long Tap Gesutre
        
        guard let userSOSFriends = UserManager.shared.userFriends?.sos_friends else {return}
        if !(userSOSFriends > 0) {
            noSOSFriendFoundAlert()
        }
    }
    
}
