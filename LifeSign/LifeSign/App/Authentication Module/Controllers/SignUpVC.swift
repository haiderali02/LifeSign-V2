//
//  SignUpVC.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class SignUpVC: LifeSignBaseVC {
    
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
    @IBOutlet weak var btnNext: DesignableButton! {
        didSet {
            btnNext.titleLabel?.font = Constants.bigButtonFont
        }
    }
    @IBOutlet weak var fullNameLabel: UILabel! {
        didSet {
            fullNameLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                fullNameLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var fullNameTextField: DesignableUITextField! {
        didSet {
            fullNameTextField.font = Constants.textFieldFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                fullNameTextField.textAlignment = .right
            }
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
        }
    }
    @IBOutlet weak var btnCheckBox: UIButton!
    
    @IBOutlet weak var termsLabel: UILabel! {
        didSet {
            termsLabel.font = Constants.labelFont
            termsLabel.tag = 1
            termsLabel.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var btnLogin: UIButton! {
        didSet {
            btnLogin.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var btnCheckboxConsent: UIButton!
    @IBOutlet weak var giveConsentLabel: UILabel! {
        didSet {
            giveConsentLabel.font = Constants.labelFont
            giveConsentLabel.tag = 2
            giveConsentLabel.isUserInteractionEnabled = true
            giveConsentLabel.text = "This is loram ipsum dummy text. This is loram ipsum dummy text. This is loram ipsum dummy text. This is loram ipsum dummy text. This is loram ipsum dummy text."
        }
    }
    @IBOutlet weak var btnShowPassword: UIButton! {
        didSet {
            btnShowPassword.tag = 1
        }
    }
    @IBOutlet weak var btnShowConfirmPassword: UIButton! {
        didSet {
            btnShowConfirmPassword.tag = 2
        }
    }
    @IBOutlet weak var alreadyAccountLabel: UILabel! {
        didSet {
            alreadyAccountLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var flagImage: UIImageView!
    
    // MARK:- PROPERTIES -
    
    var souldNavigateToLogin: ((_ index: Int, _ value: Any?) -> Void)?
    
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
        titleLabel.text = AppStrings.getSignupScreenTitle()
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        fullNameLabel.text = AppStrings.getSignupFullNameTitle()
        fullNameTextField.placeholder = AppStrings.getSignupFullNameTitle()
        passwordLabel.text = AppStrings.getPasswordString()
        passwordTextField.placeholder = AppStrings.getPasswordString()
        confirmPasswordLabel.text = AppStrings.getConfirmPasswordString()
        confirmPasswordTextField.placeholder = AppStrings.getConfirmPasswordString()
        termsLabel.text = AppStrings.getSignupTermsAndCondition()
        giveConsentLabel.text = AppStrings.getSignupUserConsent()
        alreadyAccountLabel.text = AppStrings.getSignupAlreadyaveAccountString()
        emailLabel.text = AppStrings.getEmailString()
        emailTextField.placeholder = AppStrings.getLoginEmailPlaceHolder()
        btnLogin.setTitle(AppStrings.getLoginButtonString(), for: .normal)
        btnNext.setTitle(AppStrings.getNextButtonString(), for: .normal)
        
        
        btnSelectLanguage.setTitle(LangObjectModel.shared.name, for: .normal)
        flagImage.kf.indicatorType = .activity
        flagImage.kf.setImage(with: URL(string: LangObjectModel.shared.image_rec))
        
        self.fullNameTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        let decimalCharacters = CharacterSet.decimalDigits
        guard let text = textField.text else {return}
        
        let decimalRange = text.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil || text.hasSpecialCharacters() {
            textField.text?.removeLast()
        }
        
        if text.count > 40 {
            textField.text?.removeLast()
        }
    }
    
    private func setUI () {
        btnCheckBox.setImage(R.image.ic_unchecked(), for: .normal)
        btnCheckBox.setImage(R.image.ic_checked(), for: .selected)
        btnCheckboxConsent.setImage(R.image.ic_unchecked(), for: .normal)
        btnCheckboxConsent.setImage(R.image.ic_checked(), for: .selected)
        // By default password should be hidden
        btnShowPassword.isSelected = false
        
        // Adding Tap Gesture To Checbox Labels
        self.didTapAccepTerm(self.btnCheckBox)
        termsLabel.isUserInteractionEnabled = true
        termsLabel.underline()
        termsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTermsLabe)))
        giveConsentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapConsentLabel)))
    }
    @objc func didTapTermsLabe() {
        print("Terms Tapped")
        if let controller = R.storyboard.userProfile.webViewVC() {
            controller.urlToOpen = Constants.getTermsUrl(withCountry: LangObjectModel.shared.symbol)
            self.push(controller: controller, animated: true)
        }
    }
    @objc func didTapConsentLabel() {
        print("Consent Tapped")
    }
    private func showHidePassword(buttonTag: Int) {
        if buttonTag == 1 {
            btnShowPassword.tintColor = btnShowPassword.isSelected ? R.color.appSeperatorColor() : R.color.appGreenColor()
            btnShowPassword.isSelected = !btnShowPassword.isSelected
            passwordTextField.isSecureTextEntry = !btnShowPassword.isSelected
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
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if btnCheckBox.isSelected {
            self.validateFieldsAndPassData()
        } else {
            AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getAcceptTerms(), style: .warning, controller: self)
        }
        
    }
 
    @IBAction func didTapShowPassword(_ sender: UIButton) {
        showHidePassword(buttonTag: sender.tag)
    }
    @IBAction func didTapAccepTerm(_ sender: UIButton) {
        btnCheckBox.isSelected = !btnCheckBox.isSelected
    }
    @IBAction func didTapGiveConsent(_ sender: UIButton) {
        btnCheckboxConsent.isSelected = !btnCheckboxConsent.isSelected
    }
    @IBAction func didTapLogin(_ sender: UIButton) {
        self.navigationController?.popViewControllerWithHandler {
            self.souldNavigateToLogin?(0, nil)
        }
    }
}


extension SignUpVC {
    
    func validateFieldsAndPassData() {
        self.btnNext.showLoading()
        if fullNameTextField.text?.count ?? 0 <= 1 {
            self.fullNameTextField.text?.removeAll()
            self.btnNext.hideLoading()
            return
        }
        if fullNameTextField.text != "" && fullNameTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            
            if confirmPasswordTextField.text != passwordTextField.text {
                self.btnNext.showLoading()
                AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getPasswordMismatch(), style: .info, controller: self)
                return
            } else if !Validator.validateEmail(email: emailTextField.text ?? "") {
                self.btnNext.showLoading()
                AlertController.showAlert(witTitle: AppStrings.getInvalidEmailAddressString(), withMessage: AppStrings.getInvalidEmailMessageString(), style: .danger, controller: self)
                self.btnNext.hideLoading()
                return
            } else if !Validator.validatePassword(password: passwordTextField.text ?? "") {
                self.btnNext.showLoading()
                AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getPasswordLengthString(), style: .info, controller: self)
                return
            } else {
                if let moreDetailVC = R.storyboard.authentication.signupDetailVC() {
                    moreDetailVC.userFullName = self.fullNameTextField.text ?? ""
                    moreDetailVC.userPassword = self.passwordTextField.text ?? ""
                    moreDetailVC.userEmailAddress = self.emailTextField.text ?? ""
                    moreDetailVC.userConsents = self.btnCheckboxConsent.isSelected ? "1" : "0"
                    self.push(controller: moreDetailVC, animated: true)
                }
            }
        } else {
            self.btnNext.hideLoading()
            AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getAllFieldsRequired(), style: .info, controller: self)
        }
    }
    
}
