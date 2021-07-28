//
//  NotificationManager.swift
//  LifeSign
//
//  Created by Haider Ali on 01/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

class NotificationManager {
    static let manager = Session(configuration: FriendManager.configuration())
    
    static var baseURL: String {
        return Constants.baseURL
    }
    
    static func configuration() -> URLSessionConfiguration {
        let staticHeaders = ["Content-Type": "application/json"]
        let configuration = Session.default.session.configuration
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = 30.0
        configuration.httpAdditionalHeaders = staticHeaders
        return configuration
    }
    
    static var authHeaders: HTTPHeaders {
        HTTPHeaders(["Authorization": "Bearer" + " " + UserManager.shared.access_token,
                     "X-localization": LangObjectModel.shared.symbol,
                     "Tag": UIDevice.current.identifierForVendor?.uuidString ?? "",
                     "Cache-Control": "no-cache"])
    }
}

extension NotificationManager {
    
    //
    // MARK: - NOTIFICATION LISTS -
    //
    
    static func getUserNotifications(limit: Int?, PageNumber: Int?, _ completion: @escaping (_ userNotifications: NotificationData?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            let params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            
            manager.request(baseURL + "notifications-listing",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any] {
                                        let notificationResp = NotificationResponse(JSON: response)
                                        
                                        if let reqStatus = notificationResp?.success {
                                            if reqStatus == true {
                                                completion(notificationResp?.notificationData, nil)
                                            } else {
                                                if let errors = response["errors"] as? [String] {
                                                    completion(nil, errors)
                                                }
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    } else {
                                        completion(nil, [AppStrings.getSomwthingWentWrong()])
                                    }
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
            
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    static func deleteNotification(notificationID: Int, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "notifications/\(notificationID)/destroy",
                            method: .delete,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("NotificationDeleted: \(data)")
                                    completion(true, nil)
                                case .failure(let error):
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    } else {
                                        completion(nil, [AppStrings.getSomwthingWentWrong()])
                                    }
                                    print("Error: \(error.localizedDescription)")
                                    
                                }
                            }
        } else {
            completion(false, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    static func markNotificationSeen(notificationID: Int, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "notifications/read",
                            method: .post,
                            parameters: ["notification_id":notificationID],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Notification Read: \(data)")
                                    completion(true, nil)
                                case .failure(let error):
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    } else {
                                        completion(nil, [AppStrings.getSomwthingWentWrong()])
                                    }
                                    print("Error: \(error.localizedDescription)")
                                    
                                }
                            }
        } else {
            completion(false, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
}
