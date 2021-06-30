//
//  SignupDetailVC.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import TimeZonePicker
import CoreTelephony
import LanguageManager_iOS
import CountryPickerView

class SignupDetailVC: LifeSignBaseVC {
    
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
    @IBOutlet weak var btnSelectLanguage: UIButton! {
        didSet {
            btnSelectLanguage.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var btnSignUp: DesignableButton! {
        didSet {
            btnSignUp.titleLabel?.font = Constants.bigButtonFont
        }
    }
    @IBOutlet weak var contanNumberLabel: UILabel! {
        didSet {
            contanNumberLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                contanNumberLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var contactTextField: UITextField! {
        didSet {
            contactTextField.font = Constants.textFieldFont
            contactTextField.placeholder = "Mobile Number"
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                contactTextField.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var timeZonLabel: UILabel! {
        didSet {
            timeZonLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                timeZonLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var timeZoneTextField: DesignableUITextField! {
        didSet {
            timeZoneTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                timeZoneTextField.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var zipCodeLabel: UILabel! {
        didSet {
            zipCodeLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                zipCodeLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var zipCodeTextField: DesignableUITextField! {
        didSet {
            zipCodeTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                zipCodeTextField.textAlignment = .right
            }
        }
    }
    
    @IBOutlet weak var btnLogin: UIButton! {
        didSet {
            btnLogin.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var alreadyAccountLabel: UILabel! {
        didSet {
            alreadyAccountLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var countryPickerView: CountryPickerView! {
        didSet {
            countryPickerView.delegate = self
            countryPickerView.textColor = R.color.appLightFontColor() ?? .white
            countryPickerView.font = Constants.textFieldFont
        }
    }
    @IBOutlet weak var userFullNameView: UIView!
    @IBOutlet weak var userFullNameTextField: DesignableUITextField!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    // MARK:- PROPERTIES -
    
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    var souldNavigateToLogin: ((_ index: Int, _ value: Any?) -> Void)?
    
    var userFullName: String = ""
    var userEmailAddress: String = ""
    var userPassword: String = ""
    var userConsents: String = ""
    var phoneCountryCode: String = ""
    
    var accessTokken: String = ""
    
    var LoginMode: SocialLogin = .app
    
    // MARK:- LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        setUI()
        observeLanguageChange()
    }
    
    // MARK:- FUNCTIONS -
    
    @objc func setText() {
        titleLabel.text = AppStrings.getSignupMoreDetailScreenTitle()
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        contanNumberLabel.text = AppStrings.getSignupMoreDetailContacNumber()
        contactTextField.placeholder = AppStrings.getSignupMoreDetailContacNumber()
        timeZonLabel.text = AppStrings.getSignupDetailTimeZone()
        timeZoneTextField.placeholder = AppStrings.getSignupDetailTimeZone()
        zipCodeLabel.text = AppStrings.getSignupDetailScreenZipCode()
        zipCodeTextField.placeholder = AppStrings.getSignupDetailScreenZipCode()
        btnSignUp.setTitle(AppStrings.getSignUpString(), for: .normal)
        
        userFullNameLabel.text = AppStrings.getSignupFullNameTitle()
        userFullNameTextField.placeholder = AppStrings.getSignupFullNameTitle()
        
    }
    private func setUI () {
        timeZoneTextField.text = localTimeZoneIdentifier
        timeZoneTextField.addTarget(self, action: #selector(showTimeZonePicker), for: .editingDidBegin)
        phoneCountryCode = self.countryPickerView.selectedCountry.phoneCode
        
        switch LoginMode {
        case .app, .facebook:
            self.userFullNameView.isHidden = true
        case .apple:
            if userFullName == "" {
                self.userFullNameView.isHidden = false
            }
        }
        
    }
    
    @objc func showTimeZonePicker() {
        let timeZonePicker = TimeZonePickerViewController.getVC(withDelegate: self)
        present(timeZonePicker, animated: true, completion: nil)
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    func signupUser() {
        switch LoginMode {
        case .app:
            self.proceedAppSimpleLogin()
        case .apple:
            self.proceedAppleLogin()
        case .facebook:
            self.proceedFacebookLogin()
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
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        
        if contactTextField.text != "" && zipCodeTextField.text != "" {
            self.signupUser()
        } else {
            AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getAllFieldsRequired(), style: .info, controller: self)
        }

    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        
    }
}

extension SignupDetailVC: TimeZonePickerDelegate {
    func timeZonePicker(_ timeZonePicker: TimeZonePickerViewController, didSelectTimeZone timeZone: TimeZone) {
        timeZonePicker.dismiss(animated: true) {
            self.timeZoneTextField.text = timeZone.identifier
        }
    }
}

extension SignupDetailVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.phoneCountryCode = country.phoneCode
    }
}



extension SignupDetailVC {
    
    func proceedAppSimpleLogin() {
        
        self.btnSignUp.showLoading()
        
        let params = [
            "full_name"     : self.userFullName,
            "email"         : self.userEmailAddress,
            "password"      : self.userPassword,
            "phone_code"    : self.phoneCountryCode,
            "phone_number"  : self.contactTextField.text ?? "",
            "timezone"      : self.timeZoneTextField.text ?? "",
            "zip_code"      : self.zipCodeTextField.text ?? "",
            "provider"      : "app",
            "device"        : "ios",
            "language"      : LangObjectModel.shared.symbol ?? "en",
            "fcm_token"     : Constants.APPDELEGATE.fcm_Tokken,
            "user_consent"  : self.userConsents // 0, 1 -> Boolean
        ]
        
        AuthManager.registerUser(params: params) { (userEmail, errors) in
            if errors == nil {
                self.btnSignUp.hideLoading()
                guard let verifyCodeController = R.storyboard.authentication.verifyCodeVC() else {return}
                verifyCodeController.userEmail = userEmail ?? ""
                self.push(controller: verifyCodeController, animated: true)
            } else {
                self.btnSignUp.hideLoading()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func proceedAppleLogin() {
        
        self.btnSignUp.showLoading()
        
        if self.userFullName == "" {
            if self.userFullNameTextField.text == "" {
                AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getAllFieldsRequired(), style: .warning, controller: self)
                self.btnSignUp.hideLoading()
                return
            } else {
                self.userFullName = self.userFullNameTextField.text ?? ""
            }
        }
        let params = [
            "full_name"     : self.userFullName,
            "email"         : self.userEmailAddress,
            // "password"      : self.userPassword,
            "phone_code"    : self.phoneCountryCode,
            "phone_number"  : self.contactTextField.text ?? "",
            "timezone"      : self.timeZoneTextField.text ?? "",
            "zip_code"      : self.zipCodeTextField.text ?? "",
            "provider"      : "apple",
            "device"        : "ios",
            "language"      : LangObjectModel.shared.symbol ?? "en",
            "fcm_token"     : Constants.APPDELEGATE.fcm_Tokken,
            "user_consent"  : self.userConsents, // 0, 1 -> Boolean
            "provider_id"  : self.accessTokken
        ]
        
        AuthManager.socialLogin(params: params, type: .apple, action: .create) { (status, userData, errors) in
            SocketHelper.shared.updateUserOnlineStatus()
            if errors == nil {
                // Save User
                self.btnSignUp.hideLoading()
                UserManager.shared.saveUser(user: userData!)
                let homeVC = R.storyboard.home.homeContainerVC() ?? HomeContainerVC()
                self.push(controller: homeVC, animated: true)
            } else {
                self.btnSignUp.hideLoading()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func proceedFacebookLogin() {
        
        self.btnSignUp.showLoading()
        
        let params = [
            "phone_code"    : self.phoneCountryCode,
            "phone_number"  : self.contactTextField.text ?? "",
            "timezone"      : self.timeZoneTextField.text ?? "",
            "zip_code"      : self.zipCodeTextField.text ?? "",
            "provider"      : "facebook",
            "device"        : "ios",
            "language"      : LangObjectModel.shared.symbol ?? "en",
            "fcm_token"     : Constants.APPDELEGATE.fcm_Tokken,
            "user_consent"  : self.userConsents, // 0, 1 -> Boolean
            "provider_id"  : self.accessTokken
        ]
        
        AuthManager.socialLogin(params: params, type: .facebook, action: .create) { (status, userData, errors) in
            SocketHelper.shared.establishConnection()
            if errors == nil {
                // Save User
                self.btnSignUp.hideLoading()
                UserManager.shared.saveUser(user: userData!)
                let homeVC = R.storyboard.home.homeContainerVC() ?? HomeContainerVC()
                self.push(controller: homeVC, animated: true)
            } else {
                self.btnSignUp.hideLoading()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
}
