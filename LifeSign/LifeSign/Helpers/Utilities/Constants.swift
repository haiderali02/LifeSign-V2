//
//  K.swift
//  LifeSign
//
//  Created by Haider Ali on 04/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit
import LanguageManager_iOS
import Kingfisher
import SwipeCellKit
import ImageViewer_swift


typealias ListViewMethods = UITableViewDelegate & UITableViewDataSource
typealias CollectionViewMethods = UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

struct LSAnimationConstatns {
    static let duration = 0.20
    static let delayedFactor = 0.10
}



struct Constants {
    
    static let baseURL = "https://stg.lifesigntheapp.com/api/v1/"
    static let FAQ_URL = "https://lifesigntheapp.com/wp-admin/admin-ajax.php?action=faqs&lang=\(LangObjectModel.shared.symbol)"
    static let TERMS_URL = "https://lifesigntheapp.com/wp-admin/admin-ajax.php?action=term_and_conditions&lang=\(LangObjectModel.shared.symbol)"
    
    
    static func getTermsUrl(withCountry: String) -> String {
        return "https://lifesigntheapp.com/wp-admin/admin-ajax.php?action=term_and_conditions&lang=\(withCountry == "en" ? "en" : "da")"
    }
    
    static func getFAQURL(withCountry: String) -> String {
        return "https://lifesigntheapp.com/wp-admin/admin-ajax.php?action=faqs&lang=\(withCountry == "en" ? "en" : "da")"
    }
    
    
    static let screenWidth: CGFloat = UIScreen.screens.first?.bounds.size.width ?? 0
    static let screenHeight: CGFloat = UIScreen.screens.first?.bounds.size.height ?? 0
    static let APPDELEGATE:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let MESSAGE_CHARACTER_LIMIT: Int = 140
    
    static let placeholderImage: UIImage = R.image.ic_user_placeholder() ?? UIImage()
    
    static let generalString: String = "App/Events/CounterEvent"
    
    static let socketDic = ["websocket","polling","flashsocket"]
    
    // static let timerInterval: Int = 30
    static let timerInterval: Int = 60
    static let thirthyMinBefore: Int = -30
    
    
    
    static func getCurrentUserImage() -> UIImage {
        let namePrefixLabel: UILabel = {
            let label = UILabel()
            label.font = Constants.autHeadingFont
            label.textAlignment = .center
            label.textColor = R.color.appBackgroundColor()
            return label
        }()
        
        let userImageView = UIImageView()
        userImageView.addSubview(namePrefixLabel)
        
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = R.color.appYellowColor()
        
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                namePrefixLabel.isHidden = true
                namePrefixLabel.text = UserManager.shared.getUserFullName()
                userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
            case .failure(_ ):
                // print(err.localizedDescription)
                namePrefixLabel.isHidden = false
                namePrefixLabel.text = UserManager.shared.getUserFullName()
            }
        }
        
        return userImageView.image ?? UIImage()
    }
    
    static func getFriendImage(withUrl: String, name: String) -> UIImage {
        let namePrefixLabel: UILabel = {
            let label = UILabel()
            label.font = Constants.smallFonts
            label.textAlignment = .center
            label.textColor = R.color.appBackgroundColor()
            return label
        }()
        
        let userImageView = UIImageView()
        
        userImageView.addSubview(namePrefixLabel)
        
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = R.color.appYellowColor()
        
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: withUrl)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                namePrefixLabel.isHidden = true
                namePrefixLabel.text = name
                userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
            case .failure(_ ):
                // print(err.localizedDescription)
                namePrefixLabel.isHidden = false
                namePrefixLabel.text = name
            }
        }
        
        return userImageView.image ?? UIImage()
    }
    
    struct Language {
        static let key = "languages"
    }
    static let socketIOURL: String = "https://socket.stg.lifesigntheapp.com:3000"
    static let userDefaults: UserDefaults = UserDefaults.standard
    static let USER_DATA: String = "userData"
    static let COUNTER_DATA: String = "counterData"
    static let WINING_STATS: String = "WINING_STATS"
    static let LANGUAGES_STRINGS: String = "LANGUAGES_STRINGS"
    
    static let SAVE_LANG: String = "LANG"
    static let STRINGS_DATA: String = "STRINGS_DATA"
    
    // UNITY ADS IDs -
    
//    static let LIVE_APP_ID = "3980122"
//    static let DEV_APP_ID = "4164116"

    static let LIVE_APP_ID = "3980122"
    static let DEV_APP_ID = "3980122"
    static let IS_DEV_MODE: Bool = true
    
    
//    static let LIVE_VIDE_AD_PLACEMENT = "video"
//    static let DEV_VIDE_AD_PLACEMENT = "RewardAd"
    
    static let LIVE_VIDE_AD_PLACEMENT = "rewardedVideo"
    static let DEV_VIDE_AD_PLACEMENT = "rewardedVideo"
    
//    static let UNITY_BANNER_PALCEMENT: String = "Banner_Ads"
//    static let devBanner: String = "BannerView"

    static let UNITY_BANNER_PALCEMENT: String = "Banner_Ads"
    static let devBanner: String = "Banner_Ads"
    
    
    // Fonts
    static let textFieldFont = R.font.robotoMediumItalic(size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
    static let labelFont = R.font.robotoMedium(size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
    static let labelFontBold = R.font.robotoBold(size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
    static let autHeadingFont = R.font.robotoMedium(size: 24) ?? .systemFont(ofSize: 24, weight: .medium)
    static let headerSubTitleFont = R.font.robotoMedium(size: 14) ?? .systemFont(ofSize: 14, weight: .medium)
    static let paragraphFont = R.font.robotoMedium(size: 12) ?? .systemFont(ofSize: 12, weight: .medium)
    static let headerTitleFont = R.font.robotoMedium(size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
    static let bigButtonFont = R.font.robotoMedium(size: 18) ?? .systemFont(ofSize: 18, weight: .medium)
    static let backButtonFont = R.font.robotoBold(size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
    static let sosLargeButtonFont = R.font.robotoMedium(size: 24) ?? .systemFont(ofSize: 24, weight: .medium)
    
    static let smallFonts = R.font.robotoMedium(size: 8) ?? .systemFont(ofSize: 8, weight: .medium)
    static let fontSize12 = R.font.robotoRegular(size: 12) ?? .systemFont(ofSize: 12, weight: .regular)
    
    // DEV
    
    /* static let DailySignShopItems: [String] = [
        "com.LifeSignDev.2extra_contacts",
        "com.LifeSignDev.10extra_contacts",
        "com.LifeSignDev.unlimited_friend_contacts"
    ]
    static let PokeGameShopItems: [String] = [
        "com.LifeSignDev.20autoclicks",
        "com.LifeSignDev.200autoclicks",
        "com.LifeSignDev.500autoclicks",
        "com.LifeSignDev.1000autoclicks",
        "com.LifeSignDev.5000autoclicks",
        "com.LifeSignDev.2extragames",
        "com.LifeSignDev.10extragames",
        "com.LifeSignDev.unlimitedextragames"
    ]
    static let ServicesShopItems: [String] = [
        "com.LifeSignDev.removeads",
        "com.LifeSignDev.8extra_sms",
        "com.LifeSignDev.25extra_sms",
        "com.LifeSignDev.100extra_sms",
        "com.LifeSignDev.over140ch_1contact",
        "com.LifeSignDev.over140ch_10contact",
        "com.LifeSignDev.over140ch_unlimitedcontact"
    ] */
   
    // LIVE
    
    static let DailySignShopItems: [String] = [
        "com.LifeSign.2extra_contacts",
        "com.LifeSign.10extra_contacts",
        "com.LifeSign.unlimited_friend_contacts"
    ]
    static let PokeGameShopItems: [String] = [
        "com.LifeSign.20autoclicks",
        "com.LifeSign.200autoclicks",
        "com.LifeSign.500autoclicks",
        "com.LifeSign.1000autoclicks",
        "com.LifeSign.5000autoclicks",
        "com.LifeSign.2extragames",
        "com.LifeSign.10extragames",
        "com.LifeSign.unlimitedextragames"
    ]
    static let ServicesShopItems: [String] = [
        "com.LifeSign.removeads",
        "com.LifeSign.8extra_sms",
        "com.LifeSign.25extra_sms",
        "com.LifeSign.100extra_sms",
        "com.LifeSign.over140ch_1contact",
        "com.LifeSign.over140ch_10contact",
        "com.LifeSign.over140ch_unlimitedcontact"
    ]
    
    
    static let okSignInfoData: [[String: Any]] = [
        [
            "name": AppStrings.dailySignRedColor(),
            "color": UIColor.red,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name": AppStrings.dailySignGreenColor(),
            "color": UIColor.appGreenColor,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name":  AppStrings.dailySignYellowColor(),
            "color": UIColor.appYellowColor,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name":  AppStrings.dailySignOrangeColor(),
            "color": R.color.appOrangeColor() ?? UIColor.systemOrange,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name": AppStrings.dailySignAddFriend(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_addPokeGame") ?? UIImage()
        ],
    ]
    
    
    
}


struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
