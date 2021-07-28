//
//  ChatManager.swift
//  LifeSign
//
//  Created by Haider Ali on 19/05/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

struct ChatManager {
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

extension ChatManager {
    
    //
    // MARK: - GET USER INBOX -
    //
    
    
    static func getUserInbox(searchString: String , _ completion: @escaping (_ inboxBaseResponse: InboxBaseResponse?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
        
            manager.request(baseURL + "message/inbox?search=\(searchString)",
                            method: .get,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Print: \(data)")
                                    
                                    if let response = data as? [String: Any] {
                                        let inboxBaseResp = InboxBaseResponse(JSON: response)
                                        completion(inboxBaseResp, nil)
                                        
                                        if let errors = response["errors"] as? [String] {
                                            completion(nil, errors)
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
    
    //
    // MARK: - BUY MESSAGE PKG AGAINST -
    //
    
    
    static func buyMessagePkgAgainst(friend_id: Int ,_ completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
        
            manager.request(baseURL + "message/buy-a-message",
                            method: .post,
                            parameters: ["friend_id": friend_id],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Print: \(data)")
                                    
                                    if let response = data as? [String: Any],
                                       let status = response["status"] as? Bool
                                       {
                                        
                                        if status == true {
                                            completion(status, nil)
                                        }
                                        
                                        if let errors = response["errors"] as? [String] {
                                            completion(nil, errors)
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
    
    //
    // MARK: - DELETE CHAT INBOX -
    //
    
    
    static func deleteChat(friend_id: Int ,_ completion: @escaping (_ inboxBaseResponse: InboxBaseResponse?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
        
            manager.request(baseURL + "message/delete-messages",
                            method: .delete,
                            parameters: ["friend_id": friend_id],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Print: \(data)")
                                    
                                    if let response = data as? [String: Any] {
                                        let inboxBaseResp = InboxBaseResponse(JSON: response)
                                        completion(inboxBaseResp, nil)
                                        
                                        if let errors = response["errors"] as? [String] {
                                            completion(nil, errors)
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
    
    //
    // MARK: - GET USER CHAT WITH FRIEND -
    //
    
    
    static func getUserChatWitFriend(friend_ID: Int, pageNumber: Int = 1, _ completion: @escaping (_ chatBaseResponse: ChatBaseResponse?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
        
            manager.request(baseURL + "message/index?friend_id=\(friend_ID)&page=\(pageNumber)",
                            method: .get,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Print: \(data)")
                                    
                                    if let response = data as? [String: Any] {
                                        let inboxBaseResp = ChatBaseResponse(JSON: response)
                                        completion(inboxBaseResp, nil)
                                        
                                        if let errors = response["errors"] as? [String] {
                                            completion(nil, errors)
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

    
    ///
    // MARK:- UPDATE USER PROFILE -
    ///
    
    
    static func sendMessage(image : Data?, params: [String: Any], completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
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
                    multipartFormData.append(imageData, withName: "attachment", fileName: "attachment.png", mimeType: "attachment/png")
                }
            },
            to: baseURL + "message/store", //URL Here
            method: .post,
            headers: authHeaders)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let data):
                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil)}
                    
                    if status == true {
                        print("===--- Message Sent Success ---===")
                        completion(true, nil)
                    } else {
                        print("===--- Message Sent Fail ---===")
                        if let err = apiResp["errors"] as? [String] {
                            completion(false, err)
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
                    completion(false, [error.localizedDescription])
                }
            }
    }
}
