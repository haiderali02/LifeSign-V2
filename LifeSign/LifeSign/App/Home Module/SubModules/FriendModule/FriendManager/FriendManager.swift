//
//  FriendManager.swift
//  LifeSign
//
//  Created by Haider Ali on 30/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

struct FriendManager {
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

extension FriendManager {
    
    //
    // MARK: - FRIEND MANAGER -
    //
    
    
    static func getLifeSignUsers(type: PeopleTypes, searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ lifeSinUsers: FriendsData?, _ error: [String]?, _ links: Links?) -> Void) {
        
        
        
        if Network.isAvailable {
            var params = [
                "location": type.rawValue,
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            
            manager.request(baseURL + "un-friend-users",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Print: \(data)")
                                    
                                    if let response = data as? [String: Any] {
                                        let friendsRrsponse = FriendsResponse(JSON: response)
                                        
                                        if let reqStatus = friendsRrsponse?.success {
                                            if reqStatus == true {
                                                completion(friendsRrsponse?.data, nil, friendsRrsponse?.data?.links)
                                            } else {
                                                if let errors = response["errors"] as? [String] {
                                                    completion(nil, errors, nil)
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
                                        completion(nil, [AppStrings.getSomwthingWentWrong()], nil)
                                    }
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
            
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()], nil)
        }
    }
    
    ///
    // MARL:- GET USER FRIENDS -
    ///
    
    
    static func getUserFriends(searchString: String?, limit: Int?, PageNumber: Int?, friend_Status: String? = "",_ completion: @escaping (_ userFriends: FriendsData?, _ error: [String]?, _ links: Links? ) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1,
                "friend_status": friend_Status ?? ""
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            manager.request(baseURL + "get-user-friends",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    
                                    if let response = data as? [String: Any] {
                                        let friendsRrsponse = FriendsResponse(JSON: response)
                                        print("User Friends: \(response)")
                                        if let reqStatus = friendsRrsponse?.success {
                                            if reqStatus == true {
                                                completion(friendsRrsponse?.data, nil, friendsRrsponse?.data?.links)
                                            } else {
                                                if let errors = response["errors"] as? [String] {
                                                    completion(nil, errors, nil)
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
                                        completion(nil, [AppStrings.getSomwthingWentWrong()], nil)
                                    }
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
            
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()], nil)
        }
    }
    
    
    ///
    // MARK:- SEND FRIEND REQUEST -
    ///
    
    static func sendFriendReuqest (toUserWitID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id": toUserWitID
            ]
            manager.request(baseURL + "send-friend-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("Friend Request Status \(data)")
                                        if success {
                                            completion(success, nil)
                                        } else {
                                            if let errors = response["errors"] as? [String] {
                                                completion(nil, errors)
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
            completion(false, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    ///
    // MARK:- ACCEPT REJECT FRIEND REQUEST -
    ///
    
    static func acceptRejectFriendRequest (requestStatus: String, requestID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_status":requestStatus,
                "friend_request_id": requestID
            ]
            manager.request(baseURL + "accept-or-reject-friend-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Friend Request Status \(data)")
                                        if success {
                                            completion(success, nil)
                                        } else {
                                            if let errors = resp["errors"] as? [String] {
                                                completion(nil, errors)
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
            completion(false, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    
    
    ///
    // MARK:- LOGOUT USER -
    ///
    
    static func logoutUser (completion: @escaping (_ status: Bool?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "logout",
                            method: .post,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("LogoutData: \(data)")
                                    completion(true)
                                case .failure(let error):
                                    
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    print("Error: \(error.localizedDescription)")
                                    //completion(false, [AppStrings.getSomwthingWentWrong()])
                                }
                            }
        } else {
            completion(false)
        }
    }
    
    ///
    // MARK:- UPDATE USER PROFILE -
    ///
    
    
    static func updateProfile(image : Data?, params: [String: Any], completion: @escaping (_ status: Bool?, _ userData: UserManager?,_ error: [String]?) -> Void) {
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if value is Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if element is Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                if let imageData = image {
                    multipartFormData.append(imageData, withName: "profile_image", fileName: "profile_image.png", mimeType: "profile_image/png")
                }
            },
            to: baseURL + "update-profile", //URL Here
            method: .post,
            headers: authHeaders)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let data):
                    guard let apiResp = data as? [String: Any],
                          let status = apiResp["success"] as? Bool
                    else {return completion(nil, nil, nil)}
                    
                    if status == true {
                        print("===--- USER UPDATED SUCCESS ---===")
                        guard let userResponse = apiResp["data"] as? [String: Any] else {return completion(false, nil, nil)}
                    
                        let user = UserManager.init(JSON: userResponse)
                        
                        completion(true, user, nil)
                    } else {
                        print("===--- USER UPDATED  FAILED ---===")
                        if let err = apiResp["errors"] as? [String] {
                            completion(nil,nil, err)
                        }
                    }
                case .failure(let error):
                    print("Error")
                    if response.response?.statusCode == 401 {
                        UserManager.shared.deleteUser()
                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                    }
                    completion(false, nil, [error.localizedDescription])
                }
            }
    }
    
    
    ///
    // MARK:- CHANGE SETTINGS -
    ///
    
    
    static func updateUserSettings(image : Data?, params: [String: Any], completion: @escaping (_ status: Bool?, _ userData: UserManager?,_ error: [String]?) -> Void) {
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if value is Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if element is Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                if let imageData = image {
                    multipartFormData.append(imageData, withName: "profile_image", fileName: "profile_image.png", mimeType: "profile_image/png")
                }
            },
            to: baseURL + "update-settings", //URL Here
            method: .post,
            headers: authHeaders)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let data):
                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil, nil)}
                    
                    if status == true {
                        print("===--- USER SETTINGS UPDATE SUCCESS ---===")
                        guard let userResponse = apiResp["data"] as? [String: Any] else {return completion(false, nil, nil)}
                    
                        let user = UserManager.init(JSON: userResponse)
                        
                        completion(true, user, nil)
                    } else {
                        print("===--- USER SETTINGS UPDATED FAILED ---===")
                        if let err = apiResp["errors"] as? [String] {
                            completion(nil,nil, err)
                        }
                    }
                case .failure(let error):
                    print("Error")
                    if response.response?.statusCode == 401 {
                        UserManager.shared.deleteUser()
                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                        }
                    }
                    completion(false, nil, [error.localizedDescription])
                }
            }
    }
    
    
    ///
    // MARK:- DOWNLOAD GDPR -
    ///
    
    static func getUserGDPRInfo (completion: @escaping (_ status: Bool?, _ url: URL?, _ errors: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "download-gdpr",
                            method: .get,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("GDPR DATA: \(data)")
                                    
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Friend Request Status \(data)")
                                        if success {
                                            if let gdpData = resp["data"] as? [String: Any] {
                                                if let link = gdpData["link"] as? String {
                                                    completion(true, URL(string: link), nil)
                                                }
                                            }
                                        } else {
                                            if let errors = resp["errors"] as? [String] {
                                                completion(false, nil, errors)
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(false, nil, [error.localizedDescription])
                                }
                            }
        } else {
            completion(false, nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    
    ///
    // MARK:- DELETE USER -
    
    static func deleteUser (completion: @escaping (_ status: Bool?, _ errors: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "delete-user",
                            method: .delete,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Delete User: \(data)")
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                       
                                        if success {
                                            completion(true, nil)
                                        } else {
                                            if let errors = resp["errors"] as? [String] {
                                                completion(false, errors)
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
                                    }
                                    completion(false, [error.localizedDescription])
                                }
                            }
        } else {
            completion(false, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    
    ///
    // MARK:- GET REAL TIME USER OBJECTS -
    
    static func getUpdatedUserData (completion: @escaping (_ status: Bool?, _ sosAlerts: [SOSReceivedAlert]?,_ errors: [String]?) -> Void) {
        if !UserManager.shared.isLoggedIn() {
            return
        }
        if Network.isAvailable {
            manager.request(baseURL + "realtime-userdata",
                            method: .get,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    // print("Resp REAL TIME USER: \(data)")
                                    
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        
                                        if success {
                                            if let apiData = resp["data"] as? [String: Any] {
                                                if let user = apiData["user"] as? [String: Any] {
                                                    let currentUser = UserManager.init(dic: user)
                                                    UserManager.shared.saveUser(user: currentUser)
                                                }
                                                if let counters = apiData["all_notifications"] as? [String: Any] {
                                                    let userCounters = UserCounters.init(dic: counters)
                                                    UserCounters.shared.saveCounters(counters: userCounters)
                                                }
                                                var sosAlerts = [SOSReceivedAlert]()
                                                if let sosAlertsData = apiData["sos_alert"] as? [Any] {
                                                    for obj in sosAlertsData {
                                                        let sosAlert = SOSReceivedAlert.init(dic: obj as! [String: Any])
                                                        sosAlerts.append(sosAlert)
                                                    }
                                                }
                                                completion(true, sosAlerts, nil)
                                            }
                                        } else {
                                            if let errors = resp["errors"] as? [String] {
                                                completion(false, nil, errors)
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print("Error: \(error.localizedDescription)")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(false, nil,[error.localizedDescription])
                                }
                            }
        } else {
            completion(false, nil,[AppStrings.getNetworkNotAvailableString()])
        }
    }
    
}
