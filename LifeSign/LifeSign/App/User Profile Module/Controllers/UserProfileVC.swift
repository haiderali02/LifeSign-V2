//
//  UserProfileVC.swift
//  LifeSign
//
//  Created by Haider Ali on 31/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import Kingfisher
import ImageViewer_swift

class UserProfileVC: LifeSignBaseVC {
    
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var watchConnectLabel: UILabel!
    @IBOutlet weak var requestStrangerLabel: UILabel!
    @IBOutlet weak var userBlockLabel: UILabel!
    @IBOutlet weak var strangerSwitch: UISwitch!
    @IBOutlet weak var logOutButton: DesignableButton!
    @IBOutlet weak var blockUserButton: UIButton!
    
    @IBOutlet weak var shareLabel: UILabel!
    
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    // MARK:- LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        setUI()
        observeLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        strangerSwitch.isOn = !UserManager.shared.is_stranger_request
    }
    
    // MARK:- FUNCTIONS -
    
    @objc func setText() {
        backBtn.setTitle(AppStrings.getUserProfileBackButtonString(), for: .normal)
        
        userNameLabel.text = UserManager.shared.getUserFullName()
        userEmailLabel.text = UserManager.shared.email
        userPhoneNumberLabel.text = UserManager.shared.getUserPhoneNumber()
        watchConnectLabel.text = AppStrings.getConnectWatcString()
        userBlockLabel.text = AppStrings.userFriendsBlockStreing()
        requestStrangerLabel.text = AppStrings.getRequestOnStrangerString()
        logOutButton.setTitle(AppStrings.getLogoutString(), for: .normal)
        shareLabel.text = AppStrings.shareLifeSign()
        
        
        editProfileButton.setTitle(AppStrings.getUserEditProfile(), for: .normal)
    }
    
    @objc func setUI() {
        backBtn.titleLabel?.font = Constants.backButtonFont
        userNameLabel.font = Constants.headerTitleFont
        userEmailLabel.font = Constants.labelFont
        userPhoneNumberLabel.font = Constants.labelFont
        editProfileButton.titleLabel?.font = Constants.labelFont
        watchConnectLabel.font = Constants.labelFont
        userBlockLabel.font = Constants.labelFont
        requestStrangerLabel.font = Constants.labelFont
        logOutButton.titleLabel?.font = Constants.bigButtonFont
        shareLabel.font = Constants.labelFont
        
        strangerSwitch.isOn = !UserManager.shared.is_stranger_request
        // blockUserButton.setTitle("\(UserManager.shared.blocked_Friends)", for: .normal)
        blockUserButton.titleLabel?.font = Constants.labelFont
        blockUserButton.semanticContentAttribute = .forceRightToLeft
        
        userPhoneNumberLabel.text = UserManager.shared.getUserPhoneNumber()
        userEmailLabel.isHidden = (UserManager.shared.email.contains("@apple.com")) ? true : false
        
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userNameLabel.text = UserManager.shared.getUserFullName()
        userImageView.backgroundColor = R.color.appYellowColor()
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                self.namePrefixLabel.isHidden = true
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
            case .failure(_ ):
                // print(err.localizedDescription)
                self.namePrefixLabel.isHidden = false
                self.userImageView.image = nil
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            }
        }
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setUI), name: .userUpdated, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        self.pop(controller: self)
    }
    @IBAction func didTapSettings(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.settingsVC() {
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func didTapEditProfile(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.editProfileVC() {
            self.push(controller: controller, animated: true)
        }
        
    }
    
    @IBAction func didTapMoveToConnectWatc(_ sender: UIButton) {
        guard let addWatchNavVC = R.storyboard.watchBoard.addWatchVC() else{
            return
        }
        self.push(controller: addWatchNavVC, animated: true)
    }
    
    @IBAction func didValueChangeRequestStranger(_ sender: UISwitch) {
        let params = ["is_stranger_request":self.strangerSwitch.isOn ? "0" : "1"]
        
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
    @IBAction func didTapBlockedUser(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.blockFriendVC() {
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func didTapShareApp(_ sender: UIButton) {
        //Set the default sharing message.
        UIApplication.share(sourceView: sender, AppStrings.getShareLifeSign())
    }
    @IBAction func didTapLogout(_ sender: UIButton) {
        logOutButton.showLoading()
        FriendManager.logoutUser { (logout) in
            if let shouldLogout = logout {
                if shouldLogout {
                    UserManager.shared.deleteUser()
                    SocketHelper.shared.closeConnection()
                    NotificationCenter.default.post(name: .userLogout, object: nil)
                    UserManager.shared.deleteUser()
                    self.logOutButton.hideLoading()
                    if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                        UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
}
