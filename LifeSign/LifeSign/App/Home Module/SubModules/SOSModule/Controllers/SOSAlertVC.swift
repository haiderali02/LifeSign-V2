//
//  SOSAlertVC.swift
//  LifeSign
//
//  Created by Haider Ali on 09/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import SwiftySound

class SOSAlertVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var gotItButton: UIButton! {
        didSet {
            gotItButton.titleLabel?.font = Constants.bigButtonFont
        }
    }
    @IBOutlet weak var sosBigButton: UIButton! {
        didSet {
            sosBigButton.titleLabel?.font = Constants.bigButtonFont
            sosBigButton.tintColor = .systemRed
        }
    }
    // MARK:- PROPERTIES -
   
    var sosReceived: [SOSReceivedAlert] = [SOSReceivedAlert]()
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(true, forKey: .sosScreenAppeared)
        Sound.play(file: .sosReceived, numberOfLoops: -1)
        
        print("***** AGAIN ******")
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.setValue(false, forKey: .sosScreenAppeared)
    }
    
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        UIView.animate(withDuration: 0.9) {
            self.sosBigButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } completion: { (completed) in
            UIView.animate(withDuration: 0.9) {
                self.sosBigButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { (completed) in
                self.setUI()
            }
        }
    }
        
    @objc func setText() {
        gotItButton.setTitle(AppStrings.sosGotIT(), for: .normal)
        
        for obj in self.sosReceived {
            sosBigButton.setTitle(obj.full_name, for: .normal)
        }
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapGotItButton(_ sender: UIButton) {
        Sound.stop(file: .sosSent)
        Sound.stopAll()
        for obj in self.sosReceived {
            self.showSpinner(onView: self.view)
            SOSManager.markAllSOSSeen(friendID: "\(obj.friend_id)") { (status, errors) in
                self.removeSpinner()
                Sound.stop(file: .sosSent)
                self.pop(controller: self, animation: false)
            }
        }
    }
}
