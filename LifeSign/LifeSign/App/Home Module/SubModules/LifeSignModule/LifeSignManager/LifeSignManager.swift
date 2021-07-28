//
//  LifeSignManager.swift
//  LifeSign
//
//  Created by Haider Ali on 13/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

struct LifeSignManager {
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

extension LifeSignManager {
    
    //
    // MARK: - ADD IN OKSIGN FRIEND -
    //
    
    static func addFriendToOKSIGN (friendID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id": friendID
            ]
            manager.request(baseURL + "agreement/send-agreement-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("OKSIGN Friend Request Status \(data)")
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
    
    static func acceptRejectOKSignRequest (friendID: String, agreement_Status: String, agreement_request: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id":friendID,
                "agreement_status": agreement_Status,
                "agreement_request": agreement_request
            ]
            manager.request(baseURL + "agreement/accept-or-reject-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Agreemetnt Request Status \(data)")
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
    // MARL:- GET SOS FRIENDS -
    ///
    
    
    static func getOKSignFriendsList(searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ userFriends: FriendsData?, _ error: [String]?, _ links: Links? ) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            manager.request(baseURL + "agreement/get-agreements",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Response OK: \(data as? [String: Any])")
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
    // MARK:- REMOVE USER FROM OK AGREEMENT -
    ///
    
    static func removeFromOkAgreement (agreementID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "agreement_id":agreementID,
            ]
            manager.request(baseURL + "agreement/remove-agreement",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Agreemetnt Removed \(data)")
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
    // MARK:- SEND REMINDER -
    ///
    
    static func sendReminderToUser (agreementID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "agreement_id":agreementID,
            ]
            manager.request(baseURL + "agreement/send-reminder",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Agreemetnt Removed \(data)")
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
    // MARK:- SEND I AM OK -
    ///
    
    static func sendIAMOKToUSER (agreementID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "agreement_id":agreementID,
            ]
            manager.request(baseURL + "agreement/send-ok-agreement",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Agreemetnt Removed \(data)")
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
    // MARK:- MARK AGREEMENT SEEN -
    ///
    
    static func markAgreementSeen(agreementID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "agreement_id":agreementID,
            ]
            manager.request(baseURL + "agreement/mark-as-seen",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Agreemetnt Removed \(data)")
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
    // MARK:- DAILY SIGN -
    ///
    
    
    static func addUserToDailySign (friendID: String, lifeSignTime: String, lifeSignSender: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id": friendID,
                "sign_time": lifeSignTime,
                "is_sender": lifeSignSender
            ]
            manager.request(baseURL + "daily-signs/send-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("OKSIGN Friend Request Status \(data)")
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
    // MARK:- DAILYSIGN -
    ///
    
    static func getUserDailySignFriends(searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ userFriends: FriendsData?, _ dailySignContacts: Int?, _ error: [String]?, _ links: Links? ) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            manager.request(baseURL + "daily-signs/daily-friends",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    
                                    if let response = data as? [String: Any] {
                                        let friendsRrsponse = FriendsResponse(JSON: response)
                                        
                                        if let reqStatus = friendsRrsponse?.success {
                                            if reqStatus == true {
                                                completion(friendsRrsponse?.data, friendsRrsponse?.dailySignContacts, nil, friendsRrsponse?.data?.links)
                                            } else {
                                                if let errors = response["errors"] as? [String] {
                                                    completion(nil, nil,errors, nil)
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
                                        completion(nil, nil,[AppStrings.getSomwthingWentWrong()], nil)
                                    }
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
        } else {
            completion(nil, nil,[AppStrings.getNetworkNotAvailableString()], nil)
        }
    }
    
    ///
    // MARK:- DailySIgn Request
    ///
    
    static func getDailySignRequests(searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ userFriends: FriendsData?, _ error: [String]?, _ links: Links? ) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            manager.request(baseURL + "daily-signs/friends",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    
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
    // MARK:- Accept Reject DailySign Request -
    
    static func acceptRejectDailySignReq (friendID: String, requestStaus: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id":friendID,
                "status": requestStaus
            ]
            manager.request(baseURL + "daily-signs/accept-or-reject-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Agreemetnt Request Status \(data)")
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
    // MARK:- UPDATE DailySign Time -
    ///
    
    static func updateDailySignTime (dailySignID: String, signTime: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "daily_sign_id":dailySignID,
                "sign_time": signTime
            ]
            manager.request(baseURL + "daily-signs/update-time",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Time Update Resp \(data)")
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
    // MARK:- UPDATE NickName Time -
    ///
    
    static func updateNickName (nickName: String, dailySignID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "nick_name":nickName,
                "daily_sign_id": dailySignID
            ]
            manager.request(baseURL + "daily-signs/nick-name",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Time Update Resp \(data)")
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
    // MARK:- UPDATE NickName Time -
    ///
    
    
    static func deleteFromDailySign (dailySignID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "daily_sign_id": dailySignID
            ]
            manager.request(baseURL + "daily-signs/delete-sign",
                            method: .delete,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Time Update Resp \(data)")
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
    // MARK:- Send IAM SAFE -
    ///
    
    
    static func sendIamSafe (dailySignID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "daily_sign_id": dailySignID
            ]
            manager.request(baseURL + "daily-signs/safe",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("Time Update Resp \(data)")
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
    // MARK:- Send IAM SAFE -
    ///
    
    
    static func swapeDailySign (dailySignID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "daily_sign_id": dailySignID
            ]
            manager.request(baseURL + "daily-signs/swap",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("LifeSign Swapped \(data)")
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
    
    
    static func savePackageInDatabase (identifier: String, transaction_id: String,completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "identifier": identifier,
                "transaction_id": transaction_id,
                "transaction_status": "completed"
            ]
            manager.request(baseURL + "shop/buy-package",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        if success {
                                            if let apiData = resp["data"] as? [String: Any] {
                                                let currentUser = UserManager.init(dic: apiData)
                                                UserManager.shared.deleteUser()
                                                UserManager.shared.saveUser(user: currentUser)
                                                
                                                if let counters = apiData["counters"] as? [String: Any] {
                                                    let userCounters = UserCounters.init(dic: counters)
                                                    UserCounters.shared.saveCounters(counters: userCounters)
                                                }
                                                
                                                completion(true, nil)
                                            }
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
