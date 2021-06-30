//
//  SOSManager.swift
//  LifeSign
//
//  Created by Haider Ali on 06/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

struct SOSManager {
    static let manager = Session(configuration: FriendManager.configuration())
    
    static var baseURL: String {
        return Constants.baseURL
    }
    
    static func configuration() -> URLSessionConfiguration {
        let staticHeaders = ["Content-Type": "application/json"]
        let configuration = Session.default.session.configuration
        configuration.timeoutIntervalForRequest = 30.0
        configuration.httpAdditionalHeaders = staticHeaders
        return configuration
    }
    
    static var authHeaders: HTTPHeaders {
        HTTPHeaders(["Authorization": "Bearer" + " " + UserManager.shared.access_token,
                     "X-localization": LangObjectModel.shared.symbol ?? "en",
                     "Tag": UIDevice.current.identifierForVendor?.uuidString ?? "",
                     "Cache-Control": "no-cache"])
    }
}

extension SOSManager {
    
    
    
    ///
    // MARK:- SEND SOS TO FRIENDS -
    ///
    
    static func sendSOS (completion: @escaping (_ status: Bool?, _ displayPopup: Bool?, _ message: String? , _ errors: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "sos/send-sos",
                            method: .post,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("SOS DATA: \(data)")
                                        if success {
                                            if let popUp = response["popup"] as? Bool {
                                                if popUp == true {
                                                    if let message = response["messages"] as? String {
                                                        completion(success, popUp, message, nil)
                                                        return
                                                    }
                                                } else {
                                                    completion(success, nil, nil, nil)
                                                }
                                            }
                                            completion(success, nil, nil, nil)
                                        } else {
                                            if let errors = response["errors"] as? [String] {
                                                completion(nil, nil, nil, errors)
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
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
        } else {
            completion(false, nil, nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    //
    // MARK: - GET SOS LISTING -
    //
    
    
    static func getSOSListing(searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ sosListing: SOSListData?, _ error: [String]?, _ links: Links? ) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            manager.request(baseURL + "sos/all-sos",
                            method: .get,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    
                                    if let response = data as? [String: Any] {
                                        let friendsRrsponse = SOSListingResponse(JSON: response)
                                        print("SOS LIST: \(response)")
                                        if let reqStatus = friendsRrsponse?.success {
                                            if reqStatus == true {
                                                completion(friendsRrsponse?.sosListData, nil, friendsRrsponse?.sosListData?.links)
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
    
    //
    // MARK: - ADD IN SOS FRIEND -
    //
    
    static func addFriendToSOS (friendID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id": friendID
            ]
            manager.request(baseURL + "sos/send-sos-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("SOS Friend Request Status \(data)")
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
    
    
    static func markAllSOSSeen (friendID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id": friendID
            ]
            manager.request(baseURL + "sos/mark-all-as-seen",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("SOS Marked Seen \(data)")
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
    
    //
    // MARK: - MARK SOS SEEN -
    //
    
    static func markSOSSeen (sosID: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "sos_id": sosID
            ]
            manager.request(baseURL + "sos/mark-as-seen",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("SOS Marked Seen \(data)")
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
    
    static func acceptRejectSOSRequest (friendID: String, sos_status: String, sos_request: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id":friendID,
                "sos_status": sos_status,
                "sos_request": sos_request
            ]
            manager.request(baseURL + "sos/accept-or-reject-request",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let resp = data as? [String: Any], let success = resp["success"] as? Bool {
                                        print("SOS Friend Request Status \(data)")
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
    
    
    static func getSOSFriendsList(searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ userFriends: FriendsData?, _ error: [String]?, _ links: Links? ) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            manager.request(baseURL + "sos/friends",
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
    
}
