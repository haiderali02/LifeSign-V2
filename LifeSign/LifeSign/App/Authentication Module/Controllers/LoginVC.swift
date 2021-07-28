//
//  LoginVC.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class LoginVC: LifeSignBaseVC {
    
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
    @IBOutlet weak var btnLogin: DesignableButton! {
        didSet {
            btnLogin.titleLabel?.font = Constants.bigButtonFont
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                emailLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var emailTextField: DesignableUITextField! {
        didSet {
            emailTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                emailTextField.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var passwordLabel: UILabel! {
        didSet {
            passwordLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                passwordLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var passwordTextField: DesignableUITextField! {
        didSet {
            passwordTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                passwordTextField.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var rememberLabel: UILabel! {
        didSet {
            rememberLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var btnForgotPassword: UIButton! {
        didSet {
            btnForgotPassword.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var btnShowPassword: UIButton!

    @IBOutlet weak var btnRegister: UIButton! {
        didSet {
            btnRegister.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var newUserLabel: UILabel! {
        didSet {
            newUserLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var flagImage: UIImageView!
    // MARK:- PROPERTIES -
    
    var shouldNavigateToSignUp: ((_ index: Int, _ value: Any?) -> Void)?

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
        titleLabel.text = AppStrings.getLoginScreenTitle()
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        emailLabel.text = AppStrings.getEmailString()
        emailTextField.placeholder = AppStrings.getLoginEmailPlaceHolder()
        passwordLabel.text = AppStrings.getPasswordString()
        passwordTextField.placeholder = AppStrings.getPasswordString()
        rememberLabel.text = AppStrings.getLoginRememverMe()
        btnForgotPassword.setTitle(AppStrings.getLoginForgotPasswordString(), for: .normal)
        btnLogin.setTitle(AppStrings.getLoginButtonString(), for: .normal)
        newUserLabel.text = AppStrings.getWelcomeAreYouNewUser()
        btnRegister.setTitle(AppStrings.getLoginRegisterString(), for: .normal)
        
        
        btnSelectLanguage.setTitle(LangObjectModel.shared.name, for: .normal)
        flagImage.kf.indicatorType = .activity
        flagImage.kf.setImage(with: URL(string: LangObjectModel.shared.image_rec))
        
    }
    private func setUI () {
        btnCheckBox.setImage(R.image.ic_unchecked(), for: .normal)
        btnCheckBox.setImage(R.image.ic_checked(), for: .selected)
        // By default password should be hidden
        btnShowPassword.isSelected = false
        btnCheckBox.isSelected = true
    }
    private func showHidePassword() {
        btnShowPassword.tintColor = btnShowPassword.isSelected ? R.color.appSeperatorColor() : R.color.appGreenColor()
        btnShowPassword.isSelected = !btnShowPassword.isSelected
        passwordTextField.isSecureTextEntry = !btnShowPassword.isSelected
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    private func showPasswordChangeAlert() {
        let alertController = UIAlertController(title: AppStrings.getResetPasswordTitle(), message: R.string.localizable.resetDescription(), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = AppStrings.getResetEmailPlaceHolder()
        }
        alertController.addAction(UIAlertAction(title: AppStrings.getSendString(), style: .default, handler: { (sendAction) in
            // Send Code to User
            
            let textField = alertController.textFields![0] as UITextField
                
            if let userEmail = textField.text, userEmail != "" {
                self.btnLogin.showLoading()
                
                if !Validator.validateEmail(email: userEmail) {
                    AlertController.showAlert(witTitle: AppStrings.getInvalidEmailAddressString(), withMessage: AppStrings.getInvalidEmailMessageString(), style: .danger, controller: self)
                    self.btnLogin.hideLoading()
                    return
                }
                
                AuthManager.forgotPassword(email: userEmail) { (email, errors) in
                    if errors == nil {
                        self.btnLogin.hideLoading()
                        guard let vc = R.storyboard.authentication.forgotPasswordVC() else {
                            return
                        }
                        vc.userEmail = email ?? ""
                        
                        self.push(controller: vc, animated: true)
                       
                    } else {
                        
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (cancelAction) in
            // Cancel And Dismiss
        }))
        self.present(alertController, animated: true, completion: nil)
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
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            if !Validator.validateEmail(email: emailTextField.text ?? "") {
                AlertController.showAlert(witTitle: AppStrings.getInvalidEmailAddressString(), withMessage: AppStrings.getInvalidEmailMessageString(), style: .danger, controller: self)
                return
            }
            
            let params = [
                "email": emailTextField.text!,
                "password": passwordTextField.text!,
                "device": "ios",
                "language" : LangObjectModel.shared.symbol,
                "fcm_token": Constants.APPDELEGATE.fcm_Tokken
            ]
            self.btnLogin.showLoading()
            AuthManager.loginUser(params: params) { (userActive, userData, errors) in
                self.btnLogin.hideLoading()
                SocketHelper.shared.establishConnection()
                SocketHelper.shared.updateUserOnlineStatus()
                if errors == nil {
                    self.btnLogin.hideLoading()
                    if userActive {
                        let user = UserManager()
                        user.access_token = ""
                        UserManager.shared.saveUser(user: user)
                        UserManager.shared.deleteUser()
                        UserManager.shared.saveUser(user: userData!)
                        self.btnLogin.hideLoading()
                        let homeVC = R.storyboard.home.homeContainerVC() ?? HomeContainerVC()
                        self.push(controller: homeVC, animated: true)
                    } else {
                        self.btnLogin.hideLoading()
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                } else {
                    self.btnLogin.hideLoading()
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
    }
    @IBAction func didTapForgotPassword(_ sender: UIButton) {
        showPasswordChangeAlert()
    }
    
    @IBAction func didTapShowPassword(_ sender: UIButton) {
        showHidePassword()
    }
    @IBAction func didTapRemember(_ sender: UIButton) {
        btnCheckBox.isSelected = !btnCheckBox.isSelected
    }
    @IBAction func didTapReister(_ sender: UIButton) {
        self.navigationController?.popViewControllerWithHandler {
            self.shouldNavigateToSignUp?(0, "value")
        }
    }
}
