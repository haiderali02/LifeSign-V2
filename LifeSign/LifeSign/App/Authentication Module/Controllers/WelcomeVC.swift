//
//  WelcomeVC.swift
//  LifeSign
//
//  Created by Haider Ali on 03/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices

class WelcomeVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.isHidden = true
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var btnSelectLanguage: UIButton!
    @IBOutlet weak var appleLoginBtn: DesignableButton! {
        didSet {
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                appleLoginBtn.setImage(nil, for: .normal)
            }
        }
    }
    @IBOutlet weak var facebookLoginBtn: DesignableButton! {
        didSet {
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                facebookLoginBtn.setImage(nil, for: .normal)
            }
        }
    }
    @IBOutlet weak var emailLoginBtn: DesignableButton! {
        didSet {
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                emailLoginBtn.setImage(nil, for: .normal)
            }
        }
    }
    @IBOutlet weak var registerBtn: DesignableButton!
    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    
    var showBackButton: Bool = false
    
    let connection = GraphRequestConnection()
    
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
        titleLabel.text = AppStrings.getWelcomeScreenTitle()
        appleLoginBtn.setTitle(AppStrings.getWelcomeLoginWitApple(), for: .normal)
        emailLoginBtn.setTitle(AppStrings.getWelcomeLoginWitEmail(), for: .normal)
        facebookLoginBtn.setTitle(AppStrings.getWelcomeLoginWitFacebook(), for: .normal)
        newUserLabel.text = AppStrings.getWelcomeAreYouNewUser()
        registerBtn.setTitle(AppStrings.getWelcomeRegisterAccount(), for: .normal)
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        
        btnSelectLanguage.setTitle(LangObjectModel.shared.name, for: .normal)
        
      
        btnSelectLanguage.imageView?.kf.setImage(with: URL(string: LangObjectModel.shared.image_rec))
        
        flagImage.kf.indicatorType = .activity
        flagImage.kf.setImage(with: URL(string: LangObjectModel.shared.image_rec))
        
    }
    
    private func setUI() {
        backBtn.titleLabel?.font = Constants.backButtonFont
        btnSelectLanguage.titleLabel?.font = Constants.headerTitleFont
        titleLabel.font = Constants.headerSubTitleFont
        appleLoginBtn.titleLabel?.font = Constants.bigButtonFont
        facebookLoginBtn.titleLabel?.font = Constants.bigButtonFont
        emailLoginBtn.titleLabel?.font = Constants.bigButtonFont
        registerBtn.titleLabel?.font = Constants.bigButtonFont
        newUserLabel.font = Constants.labelFont
        backBtn.isHidden = !showBackButton
    }
    
    fileprivate func proceedFacebookSignup(_ tokkenString: String) {
        if let signupDetail = R.storyboard.authentication.signupDetailVC() {
            signupDetail.accessTokken = tokkenString
            signupDetail.LoginMode = .facebook
            self.push(controller: signupDetail, animated: true)
        }
    }
    
    
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
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
    
    @IBAction func didTapAppleLogin(_ sender: UIButton) {
        self.appleLoginBtn.showLoading()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    
    @IBAction func didTapFacebookLogin(_ sender: UIButton) {
        self.facebookLoginBtn.showLoading()
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: [.publicProfile, .email], viewController: self) {
            switch $0 {
            case .cancelled:
                AlertController.showAlert(witTitle: AppStrings.getAlertString(), withMessage: AppStrings.getFBLoginCancelString(), style: .warning, controller: self)
            case .failed(_ ):
                AlertController.showAlert(witTitle: AppStrings.getErrorTitleString(), withMessage: AppStrings.getFacebookFailError(), style: .danger, controller: self)
            case .success(granted: _, declined: _, token: let tokken):
                if let tokkenString = tokken?.tokenString {
                    
                    let params = [
                        "provider_id": tokkenString,
                        "fcm_token"  : Constants.APPDELEGATE.fcm_Tokken,
                        "device": "ios",
                        "provider": "facebook",
                        "language" : LangObjectModel.shared.symbol,
                    ]
                    
                    AuthManager.socialLogin(params: params, type: .facebook, action: .login) { (status, userData, errors) in
                        if errors == nil {
                            self.facebookLoginBtn.hideLoading()
                            UserManager.shared.saveUser(user: userData!)
                            let homeVC = R.storyboard.home.homeContainerVC() ?? HomeContainerVC()
                            self.push(controller: homeVC, animated: true)
                        } else {
                            self.facebookLoginBtn.hideLoading()
                            self.proceedFacebookSignup(tokkenString)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func didTapEmailLogin(_ sender: UIButton) {
        let controller = R.storyboard.authentication.loginVC() ?? LoginVC()
        controller.shouldNavigateToSignUp = { (index, value) in
            self.didTapRegister(self.registerBtn)
        }
        push(controller: controller, animated: true)
    }
    @IBAction func didTapRegister(_ sender: UIButton) {
        let controller = R.storyboard.authentication.signUpVC() ?? SignUpVC()
        controller.souldNavigateToLogin = { (index, value) in
            self.didTapEmailLogin(self.emailLoginBtn)
        }
        push(controller: controller, animated: true)
    }
    
}

extension WelcomeVC : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let params = [
                "provider_id": userIdentifier,
                "fcm_token"  : Constants.APPDELEGATE.fcm_Tokken,
                "device": "ios",
                "provider": "apple",
                "language" : LangObjectModel.shared.symbol,
            ]
            
            AuthManager.socialLogin(params: params, type: .apple, action: .login) { (status, userData, errors) in
                if errors == nil {
                    self.appleLoginBtn.hideLoading()
                    UserManager.shared.saveUser(user: userData!)
                    let homeVC = R.storyboard.home.homeContainerVC() ?? HomeContainerVC()
                    self.push(controller: homeVC, animated: true)
                } else {
                    self.appleLoginBtn.hideLoading()
                    if let signupDetail = R.storyboard.authentication.signupDetailVC() {
                        signupDetail.accessTokken = userIdentifier
                        signupDetail.userFullName = fullName?.givenName ?? ""
                        signupDetail.userEmailAddress = email ?? ""
                        signupDetail.LoginMode = .apple
                        self.push(controller: signupDetail, animated: true)
                    }
                }
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
        self.appleLoginBtn.hideLoading()
    }
}
