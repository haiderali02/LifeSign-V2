//
//  AppDelegate.swift
//  LifeSign
//
//  Copyright © softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import IQKeyboardManagerSwift
import netfox
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import Firebase
import FirebaseMessaging
import AppTrackingTransparency

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()

    
    var deviceToken: String = ""
    var fcm_Tokken: String = ""
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        // Config Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        LangObjectModel.shared.loadLanguage()
        
        // NFX.sharedInstance().start()
        
        setupAppGeneral()
        configureNotification(application: application)
        
        StringsManager.shared.loadStrings()
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            self.fcm_Tokken = token
          }
        }
        
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App Become ACTIVE")
        if UserManager.shared.isLoggedIn() {
            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App Become InActive")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func setupAppGeneral() {
        
        // Load Current User Data
        UserManager.shared.loadUser()
        UserCounters.shared.loadCounters()
        
        // Notifications
        notificationsHandler.configure()

        // App structure
        router.loadMainAppStructure()
        
        // Connect Socket
        
        
        if UserManager.shared.isLoggedIn() {
            print("=== My AccessTokken: \(UserManager.shared.access_token) ===")
            SocketHelper.shared.establishConnection()
        }
        LanguageManager.shared.defaultLanguage = .deviceLanguage
        
        // Setting IQKeyboard Manager
        IQKeyboardManager.shared.enable = true
    }
    
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {

            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )

        }
    
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // To enable full universal link functionality add and configure the associated domain capability
        // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            deeplinkHandler.handleDeeplink(with: url)
        }
        return true
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("hello From Here")
        notificationsHandler.handleRemoteNotification(with: userInfo)
    }
}

///
// MARK:- APP DELEGATE EXTENSION -
///

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func configureNotification(application: UIApplication){
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {granted, error in
                    if granted {
                        if #available(iOS 14, *) {
                            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                                //you got permission to track
                            })
                        } else {
                            //you got permission to track, iOS 14 is not yet installed
                        }
                        print("Permession Granted for Notification")
                    } else {
                        if #available(iOS 14, *) {
                            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                                //you got permission to track
                            })
                        } else {
                            //you got permission to track, iOS 14 is not yet installed
                        }
                        print("Permession Not granter Notification")
                    }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // print("FCM token \(fcmToken ?? "NIL")")
        guard let tokken = fcmToken else {return}
        fcm_Tokken = tokken
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        // print("FCM token Refresh\(fcmToken)")
        self.fcm_Tokken = fcmToken
        // ConnectionManager.updateFcmTokken(fcmToken: fcmToken) { (resp) in }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        // print("Notifications Registered Successfully")
        // print("Device Token = \(token)")
        self.deviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // print("Notifications not available in simulator \(error)")
    }
    
    // This method will be called when app received push notifications in foreground
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("=== *** Push Received === *** ")
        PushManager.handlePush(notification.request.content.userInfo,
                               appWasActive: UIApplication.shared.applicationState == .active)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        print("=== Push Received ===")
        PushManager.handlePush(userInfo,
                               appWasActive: UIApplication.shared.applicationState == .active)
    }
}
