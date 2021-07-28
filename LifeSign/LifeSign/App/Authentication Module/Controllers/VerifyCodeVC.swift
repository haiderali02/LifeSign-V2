//
//  VerifyCodeVC.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import CBPinEntryView
import LanguageManager_iOS


class VerifyCodeVC: LifeSignBaseVC {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var otpVerificationBtn: UIButton! {
        didSet {
            otpVerificationBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                otpVerificationBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var verifcationCodeLabel: UILabel! {
        didSet {
            verifcationCodeLabel.font = Constants.headerTitleFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                verifcationCodeLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var codeSentLabel: UILabel! {
        didSet {
            codeSentLabel.font = Constants.headerSubTitleFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                codeSentLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var pinCodeView: CBPinEntryView!
    @IBOutlet weak var codeNotReceivedLabel: UILabel! {
        didSet {
            codeNotReceivedLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                codeNotReceivedLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var resendBtn: UIButton! {
        didSet {
            resendBtn.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                timerLabel.textAlignment = .right
            }
        }
    }
    
    // MARK:- PROPERTIES -
    
    var userEmail: String = ""
    var counter = 30
    var timer: Timer?
    var mode: VerifyMode = .userSignup
    
    // MARK:- VIEWLIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        setupUI()
        observeLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI () {
        pinCodeView.delegate = self
        timerLabel.isHidden = true
        resendBtn.setTitleColor(R.color.appYellowColor(), for: .normal)
        resendBtn.setTitleColor(R.color.appPlaceHolderColor(), for: .disabled)
        verifcationCodeLabel.font = Constants.autHeadingFont
        codeNotReceivedLabel.font = Constants.headerSubTitleFont
        codeSentLabel.font = Constants.headerSubTitleFont
        otpVerificationBtn.titleLabel?.font = Constants.bigButtonFont
        resendBtn.titleLabel?.font = Constants.headerTitleFont
        setupTimer()
    }
    @objc func setText() {
        codeSentLabel.text = "\(AppStrings.getOTPCodeSubTitle()) \(userEmail)"
        verifcationCodeLabel.text = AppStrings.getOTPCodeScreenTitle()
        otpVerificationBtn.setTitle(AppStrings.getOTPBackButtonString(), for: .normal)
        codeNotReceivedLabel.text = AppStrings.getOTPNotReceivedCode()
        resendBtn.setTitle(AppStrings.getOTPResend(), for: .normal)
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    @objc func updateCounter() {
        if counter > 0 {
            resendBtn.isEnabled = false
            timerLabel.isHidden = false
            timerLabel.text = "\(counter)s"
            counter -= 1
        } else {
            timer?.invalidate()
            timerLabel.isHidden = true
            resendBtn.isEnabled = true
        }
    }
    
    // MARL:- ACTIONS -
    @IBAction func didTapResendBtn(_ sender: UIButton) {
        if userEmail == "" {
            return
        }
        AuthManager.resendCode(email: userEmail) { (success, error) in
            if error == nil {
                AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getCodeResentString(), style: .success, controller: self)
                self.counter = 30
                self.setupTimer()
            } else {
                ErrorHandler.handleError(errors: error ?? [""], inController: self)
            }
        }
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VerifyCodeVC: CBPinEntryViewDelegate {
    
    func entryChanged(_ completed: Bool) {
        // Noting to do
    }
    
    func entryCompleted(with entry: String?) {
        guard let code = entry else {return}
        if mode == .forgotPassword {
            if let controller = R.storyboard.authentication.forgotPasswordVC() {
                controller.userEmail = self.userEmail
                push(controller: controller, animated: true)
            }
        } else {
            
            self.verifyUser(code: code)
            
            
        }
    }
}


extension VerifyCodeVC {
    
    func verifyUser(code: String) {
        
        AuthManager.activateAccount(email: self.userEmail, code: code) { (success, userData, errors) in
            if errors == nil {
                // Save User
                let user = UserManager()
                user.access_token = ""
                UserManager.shared.saveUser(user: user)
                UserManager.shared.deleteUser()
                UserManager.shared.saveUser(user: userData!)
                let homeVC = R.storyboard.home.homeContainerVC() ?? HomeContainerVC()
                self.push(controller: homeVC, animated: true)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
        
        
    }
    
}
