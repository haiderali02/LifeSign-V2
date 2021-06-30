//
//  ForgotPasswordVC.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import CBPinEntryView

class ForgotPasswordVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var pinCodeView: CBPinEntryView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.headerTitleFont
        }
    }
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var btnSelectLanguage: UIButton! {
        didSet {
            btnSelectLanguage.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var btnResetPassword: DesignableButton! {
        didSet {
            btnResetPassword.titleLabel?.font = Constants.bigButtonFont
        }
    }
    
    @IBOutlet weak var newPassword: UILabel! {
        didSet {
            newPassword.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                newPassword.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var newPasswordTextField: DesignableUITextField! {
        didSet {
            newPasswordTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                newPasswordTextField.textAlignment = .right
            }
            newPasswordTextField.isEnabled = false
        }
    }
    @IBOutlet weak var confirmPasswordLabel: UILabel! {
        didSet {
            confirmPasswordLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                confirmPasswordLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var confirmPasswordTextField: DesignableUITextField! {
        didSet {
            confirmPasswordTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                confirmPasswordTextField.textAlignment = .right
            }
            confirmPasswordTextField.isEnabled = false
        }
    }
 
    @IBOutlet weak var btnShowNewPassword: UIButton! {
        didSet {
            btnShowNewPassword.tag = 1
        }
    }
    @IBOutlet weak var btnShowConfirmPassword: UIButton! {
        didSet {
            btnShowConfirmPassword.tag = 2
        }
    }
    
    // MARK:- PROPERTIES -
    
    var userEmail: String = ""
    
    
    // MARK:- LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        setUI()
        observeLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- FUNCTIONS -
    
    @objc func setText() {
        titleLabel.text = "\(AppStrings.getOTPCodeSubTitle()) \(userEmail)"
        confirmPasswordLabel.text = AppStrings.getConfirmPasswordString()
        confirmPasswordTextField.placeholder = AppStrings.getConfirmPasswordString()
        btnResetPassword.setTitle(AppStrings.getResetPasswordTitle(), for: .normal)
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        newPasswordTextField.placeholder = AppStrings.getNewPasswordPasswordString()
        newPassword.text = AppStrings.getNewPasswordPasswordString()
    }
    private func setUI () {
        pinCodeView.delegate = self
    }
   
    private func updatePassword() {
        
        self.btnResetPassword.showLoading()
        let params = [
            "email":userEmail,
            "code":pinCodeView.getPinAsString(),
            "password":self.newPasswordTextField.text!
        ]
        
        AuthManager.updatePassword(params: params) { (status, errors) in
            if errors == nil {
                self.btnResetPassword.hideLoading()
                guard let vc = R.storyboard.authentication.passwordUpdatedVC() else {return}
                vc.didUpDatePassword = { (updated, value) in
                    if updated {
                        self.navigationController?.popToViewController(of: LoginVC.self, animated: true)
                    }
                }
                self.present(vc, animated: true, completion: nil)
            } else {
                self.btnResetPassword.hideLoading()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    private func showHidePassword(buttonTag: Int) {
        if buttonTag == 1 {
            btnShowNewPassword.tintColor = btnShowNewPassword.isSelected ? R.color.appSeperatorColor() : R.color.appGreenColor()
            btnShowNewPassword.isSelected = !btnShowNewPassword.isSelected
            newPasswordTextField.isSecureTextEntry = !btnShowNewPassword.isSelected
        } else {
            btnShowConfirmPassword.tintColor = btnShowConfirmPassword.isSelected ? R.color.appSeperatorColor() : R.color.appGreenColor()
            btnShowConfirmPassword.isSelected = !btnShowConfirmPassword.isSelected
            confirmPasswordTextField.isSecureTextEntry = !btnShowConfirmPassword.isSelected
        }
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        pop(controller: self)
    }

    @IBAction func didTapChooseLanguage(_ sender: UIButton) {
        guard let controller = R.storyboard.language.languagesVC() else {return}
        controller.languageMode = .fromLogin
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func didTapSowPassword(_ sender: UIButton) {
        showHidePassword(buttonTag: sender.tag)
    }
    
    @IBAction func didTapResetPassword(_ sender: UIButton) {
        
        if newPasswordTextField.text != "" && confirmPasswordTextField.text != "" {
            if newPasswordTextField.text != confirmPasswordTextField.text {
                AlertController.showAlert(witTitle: "", withMessage: "Password doesn't match", style: .info, controller: self)
            } else {
                self.updatePassword()
            }
        }
    }
}

extension ForgotPasswordVC: CBPinEntryViewDelegate {
    
    func entryChanged(_ completed: Bool) {
        // Noting to do
    }
    
    func entryCompleted(with entry: String?) {
        guard let code = entry else {return}
        print("Code: \(code)")
        newPasswordTextField.isEnabled = true
        confirmPasswordTextField.isEnabled = true
    }
}

