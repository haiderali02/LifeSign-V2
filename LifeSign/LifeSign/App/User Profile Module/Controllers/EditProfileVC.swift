//
//  EditProfileVC.swift
//  LifeSign
//
//  Created by Haider Ali on 31/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import YPImagePicker
import CountryPickerView
import ImageViewer_swift

class EditProfileVC: LifeSignBaseVC {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfileImage: DesignableButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNamelTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBOutlet weak var consentButton: UIButton!
    @IBOutlet weak var consentLabel: UILabel!
    @IBOutlet weak var saveButton: DesignableButton!
    @IBOutlet weak var emailFieldHeigt: NSLayoutConstraint!
    
    @IBOutlet weak var countryPickerView: CountryPickerView! {
        didSet {
            countryPickerView.delegate = self
            countryPickerView.textColor = R.color.appLightFontColor() ?? .white
            countryPickerView.font = Constants.textFieldFont
        }
    }
    
    @IBOutlet weak var marketingButton: UIButton!
    
    @IBOutlet weak var marketingLabel: UILabel!
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    // MAR:- IMAGE PICKER -
    
    var pickerConfiguration = YPImagePickerConfiguration()
    var picker = YPImagePicker()
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setText()
        setUI()
        observeLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapTermCondition () {
        print("Open Terms")
        if let controller = R.storyboard.userProfile.webViewVC() {
            controller.urlToOpen = Constants.getTermsUrl(withCountry: LangObjectModel.shared.symbol)
            self.push(controller: controller, animated: true)
        }
    }
    
    @objc func setText() {
        backBtn.setTitle(AppStrings.getUserEditProfile(), for: .normal)
        changeProfileImage.setTitle(AppStrings.getChangeProfileText(), for: .normal)
        firstNameLabel.text = AppStrings.getFirstNameText()
        firstNamelTextField.placeholder = AppStrings.getFirstNameText()
        lastNameLabel.text = AppStrings.getLasttNameText()
        lastNameTextField.placeholder = AppStrings.getLasttNameText()
        emailLabel.text = AppStrings.getEmailString()
        emailTextField.placeholder = AppStrings.getEmailString()
        contactLabel.text = AppStrings.getSignupMoreDetailContacNumber()
        contactTextField.placeholder = AppStrings.getSignupMoreDetailContacNumber()
        consentLabel.text = AppStrings.getSignupTermsAndCondition()
        marketingLabel.text = AppStrings.getSignupUserConsent()
        saveButton.setTitle(AppStrings.getSaveButton(), for: .normal)
        
        consentLabel.underline()
        consentLabel.isUserInteractionEnabled = true
        consentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTermCondition)))
        marketingLabel.font = Constants.labelFont
        emailLabel.text = (UserManager.shared.email.contains("@apple.com")) ? nil : AppStrings.getEmailString()
        
        pickerConfiguration.isScrollToChangeModesEnabled = true
        pickerConfiguration.onlySquareImagesFromCamera = true
        pickerConfiguration.usesFrontCamera = true
        pickerConfiguration.showsPhotoFilters = true
        pickerConfiguration.shouldSaveNewPicturesToAlbum = true
        pickerConfiguration.albumName = "LifeSign"
        pickerConfiguration.startOnScreen = YPPickerScreen.photo
        pickerConfiguration.screens = [.library, .photo]
        pickerConfiguration.showsCrop = .none
        pickerConfiguration.targetImageSize = YPImageSize.original
        pickerConfiguration.overlayView = UIView()
        pickerConfiguration.hidesStatusBar = true
        pickerConfiguration.hidesBottomBar = false
        pickerConfiguration.hidesCancelButton = false
        pickerConfiguration.preferredStatusBarStyle = UIStatusBarStyle.default
        
        self.firstNamelTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
     
        picker = YPImagePicker(configuration: pickerConfiguration)
    }
    private func setUI() {
        consentButton.setImage(R.image.ic_checked(), for: .normal)
        consentButton.setImage(R.image.ic_checked(), for: .selected)
        marketingButton.setImage(R.image.ic_unchecked(), for: .normal)
        marketingButton.setImage(R.image.ic_checked(), for: .selected)
        backBtn.titleLabel?.font = Constants.backButtonFont
        firstNameLabel.font = Constants.labelFont
        lastNameLabel.font = Constants.labelFont
        emailLabel.font = Constants.labelFont
        contactLabel.font = Constants.labelFont
        consentLabel.font = Constants.labelFont
        
        firstNamelTextField.font = Constants.textFieldFont
        lastNameTextField.font = Constants.textFieldFont
        emailTextField.font = Constants.textFieldFont
        contactTextField.font = Constants.textFieldFont
        
        saveButton.titleLabel?.font = Constants.bigButtonFont
        emailTextField.text = UserManager.shared.email
        firstNamelTextField.text = UserManager.shared.first_name
        lastNameTextField.text = UserManager.shared.last_name
        contactTextField.text = "\(UserManager.shared.phone_number)"
        
        
        
        emailLabel.isHidden = (UserManager.shared.email.contains("@apple.com")) ? true : false
        emailTextField.isHidden = (UserManager.shared.email.contains("@apple.com")) ? true : false
        emailFieldHeigt.constant = (UserManager.shared.email.contains("@apple.com")) ? 0 : 50
        emailTextField.isUserInteractionEnabled = false
        
        consentButton.isSelected = UserManager.shared.is_consent
        profileImageView.backgroundColor = R.color.appYellowColor()
        profileImageView.kf.indicatorType = .activity
        profileImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(profileImageView)
        }
        
        countryPickerView.setCountryByPhoneCode(UserManager.shared.country_code)
        
        profileImageView.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success( _):
                
                self.namePrefixLabel.isHidden = true
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                self.profileImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
            case .failure( _):
                
                self.namePrefixLabel.isHidden = false
                self.profileImageView.image = nil
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            }
        }
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        let decimalCharacters = CharacterSet.decimalDigits
        guard let text = textField.text else {return}
        
        let decimalRange = text.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil || text.hasSpecialCharacters() {
            textField.text?.removeLast()
        }
    }
    
    
    
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }

    // MARK:- ACTIONS -
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.pop(controller: self)
    }

    @IBAction func didTapPhotoButton(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.profileImageView.image = photo.image
                self.namePrefixLabel.text = nil
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    @IBAction func didTapConsentCheckBox(_ sender: UIButton) {
        AlertController.showNativeAlert(message: AppStrings.getAppWillNotWork(), controller: self)
    }
    
    
    @IBAction func didTapMarketingButton(_ sender: UIButton) {
        marketingButton.isSelected = !marketingButton.isSelected
    }
    
    @IBAction func didTapUpdateProfile(_ sender: UIButton) {
        
        self.saveButton.showLoading()
        
        let params = [
            "first_name": firstNamelTextField.text ?? UserManager.shared.first_name,
            "last_name": lastNameTextField.text ?? UserManager.shared.last_name,
            "is_consent": self.marketingButton.isSelected ? "1" : "0",
            "phone_number": self.contactTextField.text ?? UserManager.shared.phone_number,
            "country_code": self.countryPickerView.selectedCountry.phoneCode
        ] as [String : Any]
        // Upload With Image
        if let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5) {
            FriendManager.updateProfile(image: imageData, params: params) { (status, userObject, errors) in
                self.saveButton.hideLoading()
                if errors == nil {
                    guard let userObj = userObject else {return}
                    UserManager.shared.saveUser(user: userObj)
                    NotificationCenter.default.post(name: .userUpdated, object: nil)
                    NotificationCenter.default.post(name: .languageCanged, object: nil)
                    self.pop(controller: self)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        } else {
            // Upload Without Image
            FriendManager.updateProfile(image: nil, params: params) { (status, userObject, errors) in
                self.saveButton.hideLoading()
                if errors == nil {
                    guard let userObj = userObject else {return}
                    UserManager.shared.saveUser(user: userObj)
                    NotificationCenter.default.post(name: .userUpdated, object: nil)
                    NotificationCenter.default.post(name: .languageCanged, object: nil)
                    self.pop(controller: self)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
    }
}

extension EditProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        //
        
    }
}

extension String {
    func hasSpecialCharacters() -> Bool {

        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].-", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }
}
