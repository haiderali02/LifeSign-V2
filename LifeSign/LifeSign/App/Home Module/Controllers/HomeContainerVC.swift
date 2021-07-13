//
//  HomeContainerVC.swift
//  LifeSign
//
//  Created by Haider Ali on 23/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SYBadgeButton
import SwiftySound
import ImageViewer_swift

class HomeContainerVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var userImageButton: UIButton! {
        didSet {
            userImageButton.imageView?.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.text = UserManager.shared.getUserFullName()
        }
    }
    @IBOutlet weak var userNotificationButton: SYBadgeButton!
    @IBOutlet weak var userShopButton: UIButton!
    
    @IBOutlet weak var userMessagesButton: SYBadgeButton!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var providerIcon: UIImageView!
    // MARK:- TABBAR -
    
    @IBOutlet weak var sosLabel: UILabel! {
        didSet {
            sosLabel.text = "SOS"
        }
    }
    @IBOutlet weak var gameLabel: UILabel! {
        didSet {
            gameLabel.text = "Game"
        }
    }
    @IBOutlet weak var shopLabel: UILabel! {
        didSet {
            shopLabel.text = "Shop"
        }
    }
    @IBOutlet weak var friendsLabel: UILabel! {
        didSet {
            friendsLabel.text = "Friends"
        }
    }
    
    @IBOutlet weak var sosImgView: UIImageView!
    @IBOutlet weak var friendsImgView: UIImageView!
    @IBOutlet weak var btnWorldWideTop: UIButton!
    @IBOutlet weak var shopImgView: UIImageView!
    @IBOutlet weak var gameImgView: UIImageView!
    
    @IBOutlet weak var tabBarSOS: SYBadgeButton! {
        didSet {
            tabBarSOS.tag = 1
        }
    }
    @IBOutlet weak var tabBarFriend: SYBadgeButton! {
        didSet {
            tabBarFriend.tag = 2
        }
    }
    
    @IBOutlet weak var tabBarLifeSign: SYBadgeButton! {
        didSet {
            tabBarLifeSign.setBackgroundImage(R.image.ic_tabbar_LifeSign(), for: .normal)
            tabBarLifeSign.setBackgroundImage(R.image.ic_tabbar_LifeSign_selected(), for: .selected)
            tabBarLifeSign.tag = 3
        }
    }
    
    @IBOutlet weak var tabBarPokeGame: SYBadgeButton! {
        didSet {
            tabBarPokeGame.tag = 4
        }
    }
    
    @IBOutlet weak var tabBarShop: SYBadgeButton! {
        didSet {
            tabBarShop.tag = 5
        }
    }
 
    @IBOutlet weak var imgContainer: UIView!
    
    @IBOutlet weak var adView: UIView!
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    // MARK:- PROPERTIES -
    
    var tabbarContainer: HomeViewHolderVC!
    var timer: Timer?
    
    
    // MARK:- VIEW LIFW CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adView.isHidden = true
        setupUI()
        observesChanges()
        observerUserObjectChanges()
        
        
        if !UserManager.shared.remove_ad {
            // Show Banner Ad
           /* adView.isHidden = false
            UnityAds.initialize(Constants.DEV_APP_ID, testMode: true)
            let bannerView = UADSBannerView(placementId: Constants.devBanner, size: adView.frame.size)
            bannerView.delegate = self
            bannerView.load()
            
            adView.addSubview(bannerView)
            bannerView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            } */
        } else {
            adView.isHidden = true
        }
        
    }
    
    @objc func setupUI () {
        guard let tabs = self.children.first as? HomeViewHolderVC else {return}
        self.tabbarContainer = tabs
        didTapTabBarItem(tabBarLifeSign)
        UserDefaults.standard.setValue(false, forKey: .sosScreenAppeared)
        UserDefaults.standard.setValue(false, forKey: .sosMultiScreenAppeared)
        
        // CONFORM CHILD DELEGATE FOR REDIRECTION
        self.tabbarContainer.lifeSignController.sosCellDelegates = self
        configureUserImage()
        setText()
        updateCounters()
    }
    
    func observesChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupUI), name: .userUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleShopTab), name: .redirectToShop, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openFriends), name: .redirectToFriends, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUserLogout), name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameTab), name: .redirectToGame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSOSTab), name: .openSOSListing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSOSTab), name: .openSOSFriends, object: nil)
          
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getSOSReceived(_:)), name: .getSOSReceiveds, object: nil)
    }
    
    @objc func setText() {
        gameLabel.text = AppStrings.getGameTitle()
        shopLabel.text = AppStrings.getShopTabSting()
        sosLabel.text = AppStrings.getSOSTitle()
        friendsLabel.text = AppStrings.getFriendsString()
        
        if UserManager.shared.provider == .app {
            providerIcon.image = nil
        } else if UserManager.shared.provider == .facebook {
            providerIcon.image = R.image.ic_facebook_headd()
        } else if UserManager.shared.provider == .apple {
            providerIcon.image = R.image.ic_apple_head()
        }
        
    }
    
    func configureUserImage() {
        userImageButton.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageButton)
        }
        userImageButton.clipsToBounds = true
        userImageButton.backgroundColor = R.color.appYellowColor()
        userImageButton.imageView?.kf.indicatorType = .activity
        
        userNameLabel.text = UserManager.shared.getUserFullName()
        
        userImageButton.imageView?.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success(let data):
                
                self.namePrefixLabel.isHidden = true
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                self.userImageButton.setImage(data.image, for: .normal)
            // self.userImageButton.imageView?.setupImageViewer()
            case .failure(_ ):
                
                self.namePrefixLabel.isHidden = false
                self.userImageButton.setImage(nil, for: .normal)
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            }
        }
    }
    
    @objc func openFriends() {
        self.handleFriendsTab()
    }
    
    @objc func didUserLogout() {
        timer?.invalidate()
        timer = nil
    }
    @objc func getSOSReceived(_ notification: NSNotification) {
        guard let sosData = notification.object as? [String: Any],
              let sosAlertReceived = sosData["sosReceived"] as? [SOSReceivedAlert]
        else {
            return
        }
        
        if sosAlertReceived.count > 1 {
            // Show Multi Screen Alerts
            if Helper.isMultiSOSScreenVisible() {
                return
            } else {
                if let multiAlertController = R.storyboard.soS.sosMultiAlertVC() {
                    multiAlertController.sosReceived = sosAlertReceived
                    self.push(controller: multiAlertController, animated: true)
                }
            }
        } else if sosAlertReceived.count == 1 {
            // Show Single Screen Alert
            if Helper.isSOSScreenVisible() || Helper.isMultiSOSScreenVisible() {
                return
            } else {
                if let sosAlertController = R.storyboard.soS.sosAlertVC() {
                    sosAlertController.sosReceived = sosAlertReceived
                    self.push(controller: sosAlertController, animated: false)
                }
            }
        }
        
        self.updateCounters()
        
    }
    
    @objc func updateCounters() {
        userNotificationButton.badgeValue = UserCounters.shared.bell > 0 ? "\(UserCounters.shared.bell)" : nil
        self.userMessagesButton.badgeValue = UserCounters.shared.message > 0 ? "\(UserCounters.shared.message)" : nil
        tabBarSOS.badgeValue = UserCounters.shared.sos > 0 ? "\(UserCounters.shared.sos)" : nil
        tabBarFriend.badgeValue = UserCounters.shared.general_friend > 0 ? "\(UserCounters.shared.general_friend)" : nil
        tabBarPokeGame.badgeValue = UserCounters.shared.game_friend > 0 ? "\(UserCounters.shared.game_friend)" : nil
        
        NotificationCenter.default.post(name: .reloadNotificationView, object: nil)
        
    }
    
    func observerUserObjectChanges() {
        
        SocketHelper.shared.getUserLatestDataAndCounters { sosAlerts in
            
            if sosAlerts != nil {
                guard let sosAlertReceived = sosAlerts else {return}
                if sosAlertReceived.count > 1 {
                    // Show Multi Screen Alerts
                    if Helper.isMultiSOSScreenVisible() {
                        return
                    } else {
                        if let multiAlertController = R.storyboard.soS.sosMultiAlertVC() {
                            multiAlertController.sosReceived = sosAlertReceived
                            self.push(controller: multiAlertController, animated: true)
                        }
                    }
                } else if sosAlertReceived.count == 1 {
                    // Show Single Screen Alert
                    if Helper.isSOSScreenVisible() || Helper.isMultiSOSScreenVisible() {
                        return
                    } else {
                        if let sosAlertController = R.storyboard.soS.sosAlertVC() {
                            sosAlertController.sosReceived = sosAlertReceived
                            self.push(controller: sosAlertController, animated: false)
                        }
                    }
                }
            }
            self.updateCounters()
        }
        
    }
    
    // MARK:- HEADER ACTIONS -
    
    
    @IBAction func didTapUserImageButton(_ sender: UIButton) {
        if let controller = R.storyboard.userProfile.userProfileVC() {
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func didTapUserNotification(_ sender: SYBadgeButton) {
        if let controller = R.storyboard.notifications.notificationVC() {
            self.userNotificationButton.badgeValue = nil
            
            self.push(controller: controller, animated: true)
        }
    }
    
    @IBAction func didTapUserShop(_ sender: UIButton) {
        if let myPurchases = R.storyboard.shop.myPurchasesVC() {
            myPurchases.modalPresentationStyle = .overFullScreen
            myPurchases.modalTransitionStyle = .crossDissolve
            self.present(myPurchases, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapMessages(_ sender: SYBadgeButton) {
        self.userMessagesButton.badgeValue = nil
        if let inboxController = R.storyboard.chatBoard.inboxVC() {
            self.push(controller: inboxController, animated: true)
        }
    }
    @IBAction func didTapWorldWideTop(_ sender: UIButton) {
        if let leaderBoard = R.storyboard.game.leaderBoardVC() {
            self.push(controller: leaderBoard, animated: true)
        }
        
    }
    @IBAction func didTapInfo(_ sender: UIButton) {

        if self.tabBarSOS.isSelected {
            print("Show SOS INFO")
            showInfoScreen(modes: .sosInfo)
        } else if tabBarFriend.isSelected {
            print("Show Friend Info")
            showInfoScreen(modes: .friendsInfo)
        } else if tabBarLifeSign.isSelected {
            print("Show LifeSign Selected")
            showInfoScreen(modes: .dailySignInfo)
        } else if tabBarPokeGame.isSelected {
            print("Sow Game Info")
            showInfoScreen(modes: .gameInfo)
        } else if tabBarShop.isSelected {
            print("Show Shop Info")
            showInfoScreen(modes: .otherInfo)
        }
    }
    
    func showInfoScreen(modes: InfoModes) {
        if let controller = R.storyboard.home.infoVC() {
            controller.modes = modes
            controller.delegates = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK:- FOOTER ACTIONS -
    
    @IBAction func didTapTabBarItem(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.handleSOSTab()
        case 2:
            self.handleFriendsTab()
        case 3:
            self.handleLifeSignTab()
        case 4:
            self.handleGameTab()
        case 5:
            self.handleShopTab()
        default:
            return
        }
    }
    
}

extension HomeContainerVC {
    
    @objc func handleSOSTab() {
        self.sosLabel.textColor = R.color.appGreenColor()
        self.sosImgView.tintColor = R.color.appGreenColor()
        
        self.friendsLabel.textColor = R.color.appYellowColor()
        self.friendsImgView.tintColor = R.color.appYellowColor()
        
        
        self.userMessagesButton.isHidden = false
        self.userShopButton.isHidden = false
        self.gameLabel.textColor = R.color.appYellowColor()
        self.gameImgView.tintColor = R.color.appYellowColor()
        self.infoButton.isHidden = false
        self.shopLabel.textColor = R.color.appYellowColor()
        self.shopImgView.tintColor = R.color.appYellowColor()
        self.btnWorldWideTop.isHidden = true
        tabbarContainer.setViewContollerAtIndex(index: 0, animate: false)
        
        self.tabBarSOS.isSelected = true
        self.tabBarLifeSign.isSelected = false
        self.tabBarFriend.isSelected = false
        self.tabBarPokeGame.isSelected = false
        self.tabBarShop.isSelected = false
        
        imgContainer.isHidden = false
        self.userImageButton.isHidden = false
        configureUserImage()
        SocketHelper.shared.emitNotificationEventToSocket()
    }
    @objc func handleFriendsTab() {
        self.friendsLabel.textColor = R.color.appGreenColor()
        self.friendsImgView.tintColor = R.color.appGreenColor()
        self.btnWorldWideTop.isHidden = true
        self.sosLabel.textColor = R.color.appYellowColor()
        self.sosImgView.tintColor = R.color.appYellowColor()
        
        self.tabBarLifeSign.isSelected = false
        self.userMessagesButton.isHidden = false
        self.userShopButton.isHidden = false
        self.gameLabel.textColor = R.color.appYellowColor()
        self.gameImgView.tintColor = R.color.appYellowColor()
        
        self.shopLabel.textColor = R.color.appYellowColor()
        self.shopImgView.tintColor = R.color.appYellowColor()
        
        self.tabBarSOS.isSelected = false
        self.tabBarLifeSign.isSelected = false
        self.tabBarFriend.isSelected = true
        self.tabBarPokeGame.isSelected = false
        self.tabBarShop.isSelected = false
        
        self.userImageButton.isHidden = false
        self.infoButton.isHidden = false
        tabbarContainer.setViewContollerAtIndex(index: 1, animate: false)
        configureUserImage()
        imgContainer.isHidden = false
        SocketHelper.shared.emitNotificationEventToSocket()
        
    }
    @objc func handleLifeSignTab() {
        self.friendsLabel.textColor = R.color.appYellowColor()
        self.friendsImgView.tintColor = R.color.appYellowColor()
        self.btnWorldWideTop.isHidden = true
        self.sosLabel.textColor = R.color.appYellowColor()
        self.sosImgView.tintColor = R.color.appYellowColor()
        
        self.tabBarSOS.isSelected = false
        self.tabBarLifeSign.isSelected = true
        self.tabBarFriend.isSelected = false
        self.tabBarPokeGame.isSelected = false
        self.tabBarShop.isSelected = false
        
        self.gameLabel.textColor = R.color.appYellowColor()
        self.gameImgView.tintColor = R.color.appYellowColor()
        self.userImageButton.isHidden = false
        self.shopLabel.textColor = R.color.appYellowColor()
        self.shopImgView.tintColor = R.color.appYellowColor()
        self.userMessagesButton.isHidden = false
        self.userShopButton.isHidden = false
        self.infoButton.isHidden = false
        imgContainer.isHidden = false
        tabbarContainer.setViewContollerAtIndex(index: 2, animate: false)
        configureUserImage()
        SocketHelper.shared.emitNotificationEventToSocket()
        
    }
    @objc func handleGameTab() {
        self.friendsLabel.textColor = R.color.appYellowColor()
        self.friendsImgView.tintColor = R.color.appYellowColor()
        
        self.sosLabel.textColor = R.color.appYellowColor()
        self.sosImgView.tintColor = R.color.appYellowColor()
        self.btnWorldWideTop.isHidden = false
        self.tabBarLifeSign.isSelected = false
        self.userMessagesButton.isHidden = false
        self.userShopButton.isHidden = true
        self.gameLabel.textColor = R.color.appGreenColor()
        self.gameImgView.tintColor = R.color.appGreenColor()
        
        self.shopLabel.textColor = R.color.appYellowColor()
        self.shopImgView.tintColor = R.color.appYellowColor()
        self.infoButton.isHidden = false
        tabbarContainer.setViewContollerAtIndex(index: 3, animate: false)
        
        self.tabBarSOS.isSelected = false
        self.tabBarLifeSign.isSelected = false
        self.tabBarFriend.isSelected = false
        self.tabBarPokeGame.isSelected = true
        self.tabBarShop.isSelected = false
        
        self.userNameLabel.text = AppStrings.getGameTitle().uppercased()
        self.userImageButton.setImage(R.image.ic_game_board(), for: .normal)
        
        self.userImageButton.isHidden = true
        imgContainer.isHidden = true
        SocketHelper.shared.emitNotificationEventToSocket()
        
    }
    @objc func handleShopTab() {
        self.friendsLabel.textColor = R.color.appYellowColor()
        self.friendsImgView.tintColor = R.color.appYellowColor()
        self.userImageButton.isHidden = false
        self.sosLabel.textColor = R.color.appYellowColor()
        self.sosImgView.tintColor = R.color.appYellowColor()
        self.userMessagesButton.isHidden = false
        self.userShopButton.isHidden = false
        self.tabBarLifeSign.isSelected = false
        
        self.tabBarSOS.isSelected = false
        self.tabBarLifeSign.isSelected = false
        self.tabBarFriend.isSelected = false
        self.tabBarPokeGame.isSelected = false
        self.tabBarShop.isSelected = true
        imgContainer.isHidden = false
        self.gameLabel.textColor = R.color.appYellowColor()
        self.gameImgView.tintColor = R.color.appYellowColor()
        self.infoButton.isHidden = true
        self.shopLabel.textColor = R.color.appGreenColor()
        self.shopImgView.tintColor = R.color.appGreenColor()
        self.btnWorldWideTop.isHidden = true
        tabbarContainer.setViewContollerAtIndex(index: 4, animate: false)
        configureUserImage()
        SocketHelper.shared.emitNotificationEventToSocket()
        
    }
}


// MARK:- CONFORM SOS DELEGATES -

extension HomeContainerVC: SOSHomeCellProtoCol {
    func didTapSeeAll() {
        self.didTapTabBarItem(self.tabBarSOS)
        NotificationCenter.default.post(name: .openSOSFriends, object: nil)
    }
    
    func didTapTotalFriends() {
        self.didTapTabBarItem(self.tabBarSOS)
        NotificationCenter.default.post(name: .openSOSFriends, object: nil)
    }
    
    func didTapAddNewSOSFriends() {
        self.didTapTabBarItem(self.tabBarFriend)
        NotificationCenter.default.post(name: .openSOSFriends, object: nil)
    }
    
    func didTapViewRequest() {
        self.didTapTabBarItem(self.tabBarSOS)
        NotificationCenter.default.post(name: .openSOSFriends, object: nil)
    }
}


extension HomeContainerVC: UADSBannerViewDelegate {
    
    func unityAdsBannerDidLoad(_ placementId: String!, view: UIView!) {
        print("Banner Ready With ID: \(placementId ?? "")")
    }
    
    func unityAdsBannerDidUnload(_ placementId: String!) {
        print("Banner Ad Unloaded: \(placementId ?? "")")
    }
    
    func unityAdsBannerDidShow(_ placementId: String!) {
        print("Banner Ad Did Show: \(placementId ?? "")")
    }
    
    func unityAdsBannerDidHide(_ placementId: String!) {
        print("Banner Ad Did Show: \(placementId ?? "")")
    }
    
    func unityAdsBannerDidClick(_ placementId: String!) {
        print("Banner Ad Did Clicked: \(placementId ?? "")")
    }
    
    func unityAdsBannerDidError(_ message: String!) {
        print("Banner Ad Error: \(message ?? "")")
    }
    
}



extension HomeContainerVC: InfoItemDelegates {
    
    func didSelectItem(at index: Int, and mode: InfoModes) {
        if mode == .sosInfo {
            if index == 4 {
                if let controller = R.storyboard.userProfile.addSOSNumberVC() {
                    self.push(controller: controller, animated: true)
                }
            }
        }
    }
    
}
