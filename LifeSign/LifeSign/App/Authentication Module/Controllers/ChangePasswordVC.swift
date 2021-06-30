//
//  ChangePasswordVC.swift
//  LifeSign
//
//  Created by Haider Ali on 09/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ChangePasswordVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
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
    
    @IBOutlet weak var btnResetPassword: DesignableButton! {
        didSet {
            btnResetPassword.titleLabel?.font = Constants.bigButtonFont
        }
    }
    
    @IBOutlet weak var oldPassword: UILabel! {
        didSet {
            oldPassword.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                oldPassword.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var oldPasswordTextField: DesignableUITextField! {
        didSet {
            oldPasswordTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                newPasswordTextField.textAlignment = .right
            }
            oldPasswordTextField.isEnabled = true
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
            newPasswordTextField.isEnabled = true
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
            confirmPasswordTextField.isEnabled = true
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
        titleLabel.text = AppStrings.getUpdatePasswordString()
        oldPassword.text = AppStrings.getOldPasswordString()
        oldPasswordTextField.placeholder = AppStrings.getOldPasswordString()
        confirmPasswordLabel.text = AppStrings.getConfirmPasswordString()
        confirmPasswordTextField.placeholder = AppStrings.getConfirmPasswordString()
        btnResetPassword.setTitle(AppStrings.getUpdatePasswordString(), for: .normal)
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        newPasswordTextField.placeholder = AppStrings.getNewPasswordPasswordString()
        newPassword.text = AppStrings.getNewPasswordPasswordString()
    }
    private func setUI () {
        
    }
   
    private func updatePassword() {
        
        self.btnResetPassword.showLoading()
        let params = [
            "old_password": self.oldPasswordTextField.text ?? "",
            "password": self.newPasswordTextField.text ?? ""
        ]
        
        FriendManager.updateUserSettings(image: nil, params: params) { (success, userObj, errors) in
            self.btnResetPassword.hideLoading()
            if errors == nil {
                if let user = userObj {
                    UserManager.shared.saveUser(user: user)
                    NotificationCenter.default.post(name: .userUpdated, object: nil)
                    AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getPasswordUpdateSuccessMessage(), style: .success, controller: self)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.pop(controller: self)
                    }
                }
            } else {
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

    @IBAction func didTapSowPassword(_ sender: UIButton) {
        showHidePassword(buttonTag: sender.tag)
    }
    
    @IBAction func didTapResetPassword(_ sender: UIButton) {
        if newPasswordTextField.text != "" && confirmPasswordTextField.text != "" {
            if newPasswordTextField.text != confirmPasswordTextField.text {
                AlertController.showAlert(witTitle: "", withMessage: AppStrings.getNewPasswordMismatch(), style: .info, controller: self)
            } else {
                self.updatePassword()
            }
        }
    }
}
