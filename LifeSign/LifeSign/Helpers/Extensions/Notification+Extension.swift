//
//  Notification+Extension.swift
//  LifeSign
//
//  Created by Haider Ali on 15/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let pageChanged = Notification.Name("pageChanged")
    static let sosTabChanged = Notification.Name("sosTabChanged")
    static let languageCanged = Notification.Name("languageCanged")
    static let hideBackButton = Notification.Name("hideBackButton")
    static let userUpdated = Notification.Name("userUpdated")
    
    static let redirectToShop = Notification.Name("redirectToSop")
    static let redirectToGame = Notification.Name("redirectToGame")
    static let refreshData = Notification.Name("refreshData")
    static let redirectToFriends = Notification.Name("redirectToFriends")
    
    static let refreshHomeScreen = Notification.Name("refreshHomeScreen")
    static let userLogout = Notification.Name("userLogout")
    static let openSOSFriends = Notification.Name("openSOSFriends")
    static let openSOSListing = Notification.Name("openSOSListing")
    
    static let myHealth = Notification.Name("myHealth")
    static let friendsHealth = Notification.Name("friendsHealth")
    static let friendRequest = Notification.Name("friendRequest")
    
    static let getInboxLatestData = Notification.Name("getInboxLatestData")
    static let getOnlineLatestUsers = Notification.Name("getOnlineLatestUsers")
    static let reloadInbox = Notification.Name("reloadInbox")
    
    static let reloadNotificationView = Notification.Name("reloadNotificationView")
    static let reloadGameScreen = Notification.Name("reloadGameScreen")
    static let reloadGameHeader = Notification.Name("reloadGameHeader")
    static let getSOSReceiveds = Notification.Name("getSOSReceiveds")
}
