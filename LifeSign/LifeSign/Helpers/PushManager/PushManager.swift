//
//  PushManager.swift
//  LifeSign
//
//  Created by Haider Ali on 29/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit

enum PushTypes: String {
    case dailySignType = "daily_sign"
    case dailySignAccept = "daily_sign_accept"
    case dailySignSwap = "daily_sign_swap"
    case dailySignUpdateTime = "daily_sign_update_time"
    case dailySignI_am_safe = "daily_sign_i_am_safe"
    case dailySignRequest = "daily_sign_request"
    
    case okSignAgreement = "agreement"
    case okAgreementReminder = "agreement_reminder"
    case okAgreementI_am_ok = "agreement_i_am_ok"
    case okAgreementRequest = "agreement_request"
    
    case sosType = "sos"
    case sosRequest = "sos_request"
    case sosAccept = "sos_accept"
    case sosAlert = "sos_alert"
    
    case generalFriendType = "general"
    case generalFriendRequest = "friend_request"
    case generalFriendAccept = "accept_request"
    
    case shopType = "shop"
    case shopSMS = "shop_sms"
}


struct PushManager {
    
    static private func markNotificationAsSeen(notificationId: String) {
       /* ConnectionManager.markNotificationAsSeen(notificationId, completion: { response in
            switch response.result {
            case .success(let user):
                UserManager.currentUser = user
            case .failure:
                break
            }
        }) */
    }
    
    static private func openMail(payload: [AnyHashable: Any], changeTabTo idx: Int) {
        /* guard let mailId = payload["mail_id"] as? String, !mailId.isEmpty else {
            //Mail id was not present, so lets open the notification tab instead
            _ = RouterManager.changeSelectedTabTo(index: idx)
            return
        }
        RouterManager.openMail(id: mailId, animated: false) */
    }
    
    static func handlePush(_ payload: [AnyHashable: Any], appWasActive: Bool) {
        guard let type = payload["type"] as? String, let subType = payload["sub_type"] as? String,
            let pushType = PushTypes(rawValue: type),
            UserManager.shared.isLoggedIn() else {
            return
        }
        print("Push payload: \(payload), type: \(type)")
        
        //Actively setting app badge count if present
        (payload["aps"] as? NSDictionary)
            .flatMap { $0["badge"] as? Int }
            .map { UIApplication.shared.applicationIconBadgeNumber = $0 }
         
        if appWasActive {
            fetchUser()
            // return
        }
        
        (payload["notification_id"] as? String).map(markNotificationAsSeen)
        handleNotificationTaped(notification: pushType, subType: subType)
    
        NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
    }
    
    private static func fetchUser() {
        NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
    }
    
    
    private static func handleNotificationTaped(notification: PushTypes, subType: String) {
        switch notification {
        case .generalFriendType:
            switch subType {
            case .generalFriendRequest, .generalFriendAccept:
                NotificationCenter.default.post(name: .redirectToFriends, object: nil)

            default:
                return
            }
        case .shopType:
            switch subType {
            case .shopSMS:
                NotificationCenter.default.post(name: .redirectToShop, object: nil)
            default:
                return
            }
        case .sosType:
            switch subType {
            case .sosRequest, .sosAccept:
                NotificationCenter.default.post(name: .openSOSFriends, object: nil)
            case .sosAlert:
                NotificationCenter.default.post(name: .openSOSListing, object: nil)

            default:
                return
            }
        case .okSignAgreement:
            switch subType {
            case .okAgreementReminder:
                if let controller = R.storyboard.lifeSign.okSignVC() {
                    controller.mode = .tellFriend
                   //  self.push(controller: controller, animated: true)
                }
            case .okAgreementRequest:
                if let controller = R.storyboard.lifeSign.okSignVC() {
                    controller.mode = .tellFriend
                   // self.push(controller: controller, animated: true)
                }
            case .okAgreementI_am_ok:
                if let controller = R.storyboard.lifeSign.okSignVC() {
                    controller.mode = .checkFriend
                    // self.push(controller: controller, animated: true)
                }
            default:
                return
            }
        case .dailySignType:
            switch subType {
            case .dailySignAccept, .dailySignSwap:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                    // self.push(controller: controller, animated: true)
                }
            case .dailySignRequest:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                   // self.push(controller: controller, animated: true)
                }
            case .dailySignI_am_safe:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                   // self.push(controller: controller, animated: true)
                }
            case .dailySignUpdateTime:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                   // self.push(controller: controller, animated: true)
                }
            default:
                return
            }
        default:
            return
        }
    }
    
}

