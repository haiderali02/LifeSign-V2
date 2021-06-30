//
//  AddSOSNumberVC.swift
//  LifeSign
//
//  Created by Haider Ali on 12/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import CountryPickerView

class AddSOSNumberVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var saveButton: DesignableButton!
    @IBOutlet weak var countryPickerView: CountryPickerView! {
        didSet {
            countryPickerView.delegate = self
            countryPickerView.textColor = R.color.appLightFontColor() ?? .white
            countryPickerView.font = Constants.textFieldFont
        }
    }
    
    
    // MARK:- PROPERTIES -
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
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
        backBtn.titleLabel?.font = Constants.backButtonFont
        
        userNameLabel.font = Constants.labelFont
        contactLabel.font = Constants.labelFont
        contactTextField.font = Constants.textFieldFont
        saveButton.titleLabel?.font = Constants.bigButtonFont
        
        profileImageView.backgroundColor = R.color.appYellowColor()
        profileImageView.kf.indicatorType = .activity
        profileImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(profileImageView)
        }
        contactTextField.placeholder = AppStrings.getSignupMoreDetailContacNumber()
        
        if UserManager.shared.sos_number != 0 {
            contactTextField.text = "\(UserManager.shared.sos_number)"
        }
        
        countryPickerView.setCountryByPhoneCode(UserManager.shared.sos_country_code)
        profileImageView.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                self.namePrefixLabel.isHidden = true
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            case .failure(_ ):
                // print(err.localizedDescription)
                self.namePrefixLabel.isHidden = false
                self.profileImageView.image = nil
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            }
        }
        
    }
    
    @objc func setText() {
        backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
        userNameLabel.text = UserManager.shared.getUserFullName()
        saveButton.setTitle(AppStrings.getSaveButton(), for: .normal)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    @IBAction func didTapSave(_ sender: UIButton) {
        if contactTextField.text == "" {
            return
        }
        self.saveButton.showLoading()
        let params = [
            "sos_number": self.contactTextField.text ?? "\(UserManager.shared.sos_number)",
            "sos_country_code": self.countryPickerView.selectedCountry.phoneCode
        ]
        FriendManager.updateUserSettings(image: nil, params: params) { (statu, userObj, errors) in
            self.saveButton.hideLoading()
            if errors == nil {
                if let user = userObj {
                    UserManager.shared.saveUser(user: user)
                    NotificationCenter.default.post(name: .userUpdated, object: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.pop(controller: self)
                    }
                }
                AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getSOSNumberSuccessMessage(), style: .success, controller: self)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
}

extension AddSOSNumberVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        //
    }
}
