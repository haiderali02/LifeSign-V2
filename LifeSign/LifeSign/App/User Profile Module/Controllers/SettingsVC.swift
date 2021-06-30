//
//  SettingsVC.swift
//  LifeSign
//
//  Created by Haider Ali on 08/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import StoreKit

class SettingsVC: LifeSignBaseVC {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var readButton: UIButton! {
        didSet {
            readButton.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var faqLabel: UILabel! {
        didSet {
            faqLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var requestFromStrangerLabel: UILabel! {
        didSet {
            requestFromStrangerLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var faqDnandEnLabel: UILabel! {
        didSet {
            faqDnandEnLabel.font = Constants.paragraphFont
        }
    }
    @IBOutlet weak var strangerSwitch: UISegmentedControl! {
        didSet {
            let unSelectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appYellowColor]
            let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appBoxColor]
            strangerSwitch.setTitleTextAttributes(unSelectedAttribute, for: .normal)
            strangerSwitch.setTitleTextAttributes(selectedAttribute, for: .selected)
            strangerSwitch.selectedSegmentTintColor = UIColor.appYellowColor
        }
    }
    @IBOutlet weak var soundOnOfLabel: UILabel! {
        didSet {
            soundOnOfLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var soundSwitch: UISegmentedControl! {
        didSet {
            let unSelectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appYellowColor]
            let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appBoxColor]
            soundSwitch.setTitleTextAttributes(unSelectedAttribute, for: .normal)
            soundSwitch.setTitleTextAttributes(selectedAttribute, for: .selected)
            soundSwitch.selectedSegmentTintColor = UIColor.appYellowColor
        }
    }
    @IBOutlet weak var sosNumberLabel: UILabel! {
        didSet {
            sosNumberLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var addSOSNumber: UIButton! {
        didSet {
            addSOSNumber.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var linkForTermsLabel: UILabel! {
        didSet {
            linkForTermsLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var readLinkButton: UIButton! {
        didSet {
            readLinkButton.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var termsEnAndDNLabel: UILabel! {
        didSet {
            termsEnAndDNLabel.font = Constants.paragraphFont
        }
    }
    @IBOutlet weak var downloadGDPRLabel: UILabel! {
        didSet {
            downloadGDPRLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var deleteProfileLabel: UILabel! {
        didSet {
            deleteProfileLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var gdprEnDNLabel: UILabel! {
        didSet {
            gdprEnDNLabel.font = Constants.paragraphFont
        }
    }
    @IBOutlet weak var deleteButton: UIButton! {
        didSet {
            deleteButton.titleLabel?.font = Constants.labelFont
        }
    }
    
    @IBOutlet weak var changePasswordLabel: UILabel! {
        didSet {
            changePasswordLabel.font = Constants.labelFont
        }
    }
    
    @IBOutlet weak var changePasswordButton: UIButton! {
        didSet {
            changePasswordButton.titleLabel?.font = Constants.labelFont
        }
    }
    
    @IBOutlet weak var restorePurchaseLabel: UILabel! {
        didSet {
            restorePurchaseLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var btnSelectLanguage: UIButton!
    @IBOutlet weak var flagImage: UIImageView!
    
    // MARK:- PROPERTIES -
    var purchasedID: String = ""
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        SKPaymentQueue.default().add(self)
        self.strangerSwitch.selectedSegmentIndex = UserManager.shared.is_stranger_request ? 0 : 1
        self.soundSwitch.selectedSegmentIndex = UserManager.shared.is_sound_on ? 0 : 1
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getSettingsTitle(), for: .normal)
        self.changePasswordLabel.text = AppStrings.getUpdatePasswordString()
        self.changePasswordButton.setTitle(AppStrings.getChangeString(), for: .normal)
        
        if UserManager.shared.getUserSOSNumber() == "0" {
            self.addSOSNumber.setTitle(AppStrings.getAddFriendString(), for: .normal)
        } else {
            self.addSOSNumber.setTitle(UserManager.shared.getUserSOSNumber(), for: .normal)
        }
        
        soundSwitch.setTitle(AppStrings.getONString(), forSegmentAt: 0)
        soundSwitch.setTitle(AppStrings.getOffString(), forSegmentAt: 1)
        
        strangerSwitch.setTitle(AppStrings.getONString(), forSegmentAt: 0)
        strangerSwitch.setTitle(AppStrings.getOffString(), forSegmentAt: 1)
        
        self.deleteButton.setTitle(AppStrings.getDeleteString(), for: .normal)
        self.readButton.setTitle(AppStrings.getReadString(), for: .normal)
        self.readLinkButton.setTitle(AppStrings.getReadString(), for: .normal)
        self.faqLabel.text = AppStrings.getFAQString()
        self.faqDnandEnLabel.text = AppStrings.getOnlyInEngAndDanish()
        self.termsEnAndDNLabel.text = AppStrings.getOnlyInEngAndDanish()
        self.deleteProfileLabel.text = AppStrings.getDeleteProfileString()
        self.soundOnOfLabel.text = AppStrings.getSoundOnOfString()
        self.linkForTermsLabel.text = AppStrings.linksForTermCondition()
        self.gdprEnDNLabel.text = AppStrings.getOnlyInEngAndDanish()
        self.requestFromStrangerLabel.text = AppStrings.getDontWantRqStrngr()
        self.sosNumberLabel.text = AppStrings.getAddSOSNumString()
        self.downloadGDPRLabel.text = AppStrings.getDownloadGDPR()
        self.restorePurchaseLabel.text = AppStrings.restorePurchases()
        
        
        btnSelectLanguage.setTitle(LangObjectModel.shared.name, for: .normal)
        flagImage.kf.indicatorType = .activity
        flagImage.kf.setImage(with: URL(string: LangObjectModel.shared.image_rec))
        
        
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .userUpdated, object: nil)
    }
    
    func showMutedAlert() {
        let alertController = UIAlertController(title: AppStrings.getAlertString(), message: AppStrings.appWillNotWorkOptimally(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getOKButtonString(), style: .default, handler: { _  in
            // Dismiss Siliently
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func saveInAppInDataBase(purchaseID: String) {
        self.showSpinner(onView: self.view)
        LifeSignManager.savePackageInDatabase(identifier: purchaseID, transaction_id: Helper.getRandomAlphaNumericString(length: 8)) { status, errors in
            self.removeSpinner()
            if errors == nil {
                // AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getPurchaseSuccessString(), style: .success, controller: self)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    
    // MARK:- ACTIONS -
    
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    
    @IBAction func didTapLanguage(_ sender: UIButton) {
        guard let controller = R.storyboard.language.languagesVC() else {return}
        controller.languageMode = .fromLogin
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func didTapReadFAQ(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.webViewVC() {
            controller.urlToOpen = Constants.getFAQURL(withCountry: LangObjectModel.shared.symbol )
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func strangerSwitch(_ sender: UISegmentedControl) {
        let params = ["is_stranger_request": self.strangerSwitch.selectedSegmentIndex == 0 ? "1" : "0"]
        
        FriendManager.updateUserSettings(image: nil, params: params) { (status, userData, errors) in
            if errors == nil {
                if let user = userData {
                    UserManager.shared.saveUser(user: user)
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @IBAction func soundSwitch(_ sender: UISegmentedControl) {
        let params = ["is_sound_on":self.soundSwitch.selectedSegmentIndex == 0 ? "1" : "0"]
        
        if self.soundSwitch.selectedSegmentIndex != 0  {
            self.showMutedAlert()
        }
        
        FriendManager.updateUserSettings(image: nil, params: params) { (status, userData, errors) in
            if errors == nil {
                if let user = userData {
                    UserManager.shared.saveUser(user: user)
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @IBAction func didTapAddSOSButton(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.addSOSNumberVC() {
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func didTapReadTermsButton(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.webViewVC() {
            controller.urlToOpen = Constants.getTermsUrl(withCountry: LangObjectModel.shared.symbol )
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func downloadGDPRInfo(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        FriendManager.getUserGDPRInfo { (status, url, errors) in
            self.removeSpinner()
            if errors == nil {
                guard let url = url else {return}
                UIApplication.shared.open(url)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @IBAction func didTapDeleteProfile(_ sender: UIButton) {
        let alertController = UIAlertController(title: AppStrings.getAreYouSureString(), message: AppStrings.getDeleteAccountString(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getDeleteString(), style: .destructive, handler: { (_ ) in
            // Delete User
            FriendManager.deleteUser { (status, errors) in
                if errors == nil {
                    UserManager.shared.deleteUser()
                    if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                        UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Cancel
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapRestorePurchase(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        if (SKPaymentQueue.canMakePayments()) {
          SKPaymentQueue.default().restoreCompletedTransactions()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.removeSpinner()
            
            AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getRestoreSuccessString(), style: .success, controller: self)
            
        }
    }
    
    
    @IBAction func didTapChangePassword(_ sender: UIButton) {
        if let controller = R.storyboard.authentication.changePasswordVC() {
            self.push(controller: controller, animated: true)
        }
    }
}



extension SettingsVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        self.showSkeleton()
        transactions.forEach({
            switch $0.transactionState {
            case .purchased:
                print("Item Purchased")
                self.hideSkeleton()
                
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("Failed To Purchased")
                self.hideSkeleton()
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("Purchased Restored")
                // self.saveInAppInDataBase(purchaseID: $0.transactionIdentifier ?? "")
                self.hideSkeleton()
                SKPaymentQueue.default().finishTransaction($0)
            case .deferred:
                print("Defferred")
                self.hideSkeleton()
            case .purchasing:
                print("Purchasing In Process")
                self.hideSkeleton()
            @unknown default:
                self.hideSkeleton()
                SKPaymentQueue.default().finishTransaction($0)
                return
            }
        })
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            
        }
    }
}
