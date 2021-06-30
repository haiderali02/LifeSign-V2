//
//  LSEnums.swift
//  LifeSign
//
//  Created by Haider Ali on 30/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    static let pending = "pending"
    static let accepted = "accepted"
    static let blocked = "blocked"
    static let waiting = "waiting"
    static let rejected = "rejected"
    static let cancel = "cancel"
    static let notAdded = "not_added"
    static let free = "free"
    static let start = "start"
    
    static let sosSent = "sos_sent_sound.mp3"
    static let okSignReceived = "iamOk_notification.mp3"
    static let sosReceived = "sos_alert_sound.mp3"
    
    static let sosScreenAppeared = "SOSAlertVC"
    static let sosMultiScreenAppeared = "SOSMultiAlertVC"
    
    static let single = "S"
    static let dual = "D"
    
    static let rewardAutoClicks = "click"
    static let rewardSMS = "sms"
    static let downloadApp = "download_app"
}

enum LanguageMode {
    case fromSplash
    case fromSettings
    case fromLogin
}

enum VerifyMode {
    case userSignup
    case forgotPassword
}

enum UserCellType {
    case myFriend
    case people
    case inviteFriends
    case notification
    case sosListing
    case inboxListing
}

enum PeopleTypes: String {
    case local
    case international
    case national
}

enum SocialLogin: String {
    case apple
    case facebook
    case app
}

enum SocialLoginAction: String {
    case login
    case create
}


enum LSSoundMode {
    case play
    case stop
}

enum CollectionType {
    case acceptReject
    case sosFriend
}


enum SOSScreenModes {
    case previewFromTab
    case navigatedFromHome
}

enum OKSignStats {
    case checkFriend
    case tellFriend
    case acceptReject
    case gotIt
    case reminderReceived
}

enum DailySignMode {
    case allFriends
    case friendRequest
}

enum OKSignMode {
    case checkFriend
    case tellFriend
}

enum FriendsScreenMode {
    case friends
    case Inbox
    case addNew
    case game
}

enum InfoModes {
    case friendsInfo
    case sosInfo
    case gameInfo
    case dailySignInfo
    case otherInfo
    case hitListInfo
}
