//
//  NotificationsHandler.swift
//  LifeSign
//
//  Copyright © softwarealliance. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import AppTrackingTransparency


class NotificationsHandler: NSObject {

    // MARK: Public methods

    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }

    func registerForRemoteNotifications() {
        let application = UIApplication.shared
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {_, _ in
            // do nothing for now
          
            
        }

        application.registerForRemoteNotifications()
    }

    func handleRemoteNotification(with userInfo: [AnyHashable: Any]) {
        print("hello From Handler")
    }
}

extension NotificationsHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
    }
}
