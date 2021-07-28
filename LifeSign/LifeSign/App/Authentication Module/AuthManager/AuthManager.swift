//
//  AuthManager.swift
//  LifeSign
//
//  Created by Haider Ali on 25/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

struct AuthManager {
    static let manager = Session(configuration: AuthManager.configuration())
    
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
        HTTPHeaders(["Authorization": "",
                     "X-localization": LangObjectModel.shared.symbol,
                     "Tag": UIDevice.current.identifierForVendor?.uuidString ?? "",
                     "Cache-Control": "no-cache"])
    }
}

extension AuthManager {
    
    //
    // MARK: - Authentication
    //
   
    static func loginUser(params: [String: Any], _ completion: @escaping (_ isUserActive: Bool, _ userData: UserManager?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "login",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let responseData = data as? [String: Any], let status = responseData["success"] as? Bool else {return}
                                    
                                    if status == true {
                                        print("===--- LOGIN SUCCESS ---===")
                                        guard let userResponse = responseData["data"] as? [String: Any] else {return completion(false, nil, nil)}
                                    
                                        let user = UserManager.init(JSON: userResponse)
                                        
                                        completion(true, user, nil)
                                        
                                    } else {
                                        if let accountActive = responseData["account_active"] as? Bool {
                                            if !accountActive {
                                                guard let erros = responseData["errors"] as? [String] else {return completion(false, nil, nil)}
                                                completion(accountActive, nil, erros)
                                            } else {
                                                guard let erros = responseData["errors"] as? [String] else {return completion(false, nil, nil)}
                                                
                                                completion(false, nil, erros)
                                            }
                                        } else {
                                            guard let erros = responseData["errors"] as? [String] else {return completion(false, nil, nil)}
                                            
                                            completion(false, nil, erros)
                                        }
                            
                                    }
                                case .failure(let error):
                                    print("****--- LOGIN FAILED ---**** \n \(error.localizedDescription)")
                                }
                            }
        } else {
            completion(false, nil, [AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    
    static func updateFcmTokken (fcmToken: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "Auth/updateFCM?fcm_token=\(fcmToken)",
                            method: .post,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON(completionHandler: completion)
        }
    }
    
    static func getAllLanguages (completion: @escaping (AFDataResponse<Any>) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "languages",
                            method: .get,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON(completionHandler: completion)
        }
    }
    
    static func getLanguageForCountry (symbol: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        if Network.isAvailable {
            
            var langHeader: HTTPHeaders {
               HTTPHeaders(["Authorization": "",
                            "X-localization": symbol,
                            "Tag": UIDevice.current.identifierForVendor?.uuidString ?? "",
                            "Cache-Control": "no-cache"])
           }
            
            manager.request(baseURL + "get-ios-translations",
                            method: .get,
                            parameters: nil,
                            headers: langHeader).validate().responseJSON(completionHandler: completion)
        }
    }
    
    static func forgotPassword (email: String, completion: @escaping (_ userEmail: String?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "forget-password",
                            method: .post,
                            parameters: ["email":email],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil)}
                                    
                                    if status == true {
                                        print("===--- RESET SUCCESS ---===")
                                        if let userData = apiResp["data"] as? [String: Any] {
                                            if let userEmail = userData["email"] as? String {
                                                completion(userEmail, nil)
                                            }
                                        }
                                    } else {
                                        print("===--- RESET FAILED ---===")
                                        if let err = apiResp["errors"] as? [String] {
                                            completion(nil,err)
                                        }
                                    }
                                    
                                case .failure(let error):
                                    
                                    print("===--- RESET FAILED ---===")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(nil, [error.localizedDescription])
                                }
                            }
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    
    static func updatePassword (params: [String: Any], completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "reset-password-change",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil)}
                                    
                                    if status == true {
                                        print("===--- UPDATE SUCCESS ---===")
                                        completion(status, nil)
                                    } else {
                                        print("===--- UPDATE FAILED ---===")
                                        if let err = apiResp["errors"] as? [String] {
                                            completion(nil,err)
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("===--- UPDATE FAILED ---===")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(nil, [error.localizedDescription])
                                }
                            }
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    
    static func resendCode (email: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "resend-code-register",
                            method: .post,
                            parameters: ["email":email],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil)}
                                    
                                    if status == true {
                                        print("===--- CODE RESEND SUCCESS ---===")
                                        completion(status, nil)
                                    } else {
                                        print("===--- CODE RESEND FAILED ---===")
                                        if let err = apiResp["errors"] as? [String] {
                                            completion(nil,err)
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("===--- CODE RESEND FAILED ---===")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(nil, [error.localizedDescription])
                                }
                            }
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    
    static func registerUser (params: [String: Any], completion: @escaping (_ userEmail: String?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "register",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil)}
                                    
                                    if status == true {
                                        print("===--- REGISTER SUCCESS ---===")
                                        if let respData = apiResp["data"] as? [String: Any] {
                                            if let email = respData["email"] as? String {
                                                completion(email, nil)
                                            }
                                        }
                                    } else {
                                        print("===--- REGISTER FAILED ---===")
                                        if let err = apiResp["errors"] as? [String] {
                                            completion(nil,err)
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("===--- REGISTER FAILED ---===")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(nil, [error.localizedDescription])
                                }
                            }
        } else {
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    static func activateAccount (email: String, code: String, completion: @escaping (_ status: Bool?, _ userData: UserManager?,_ error: [String]?) -> Void) {
        if Network.isAvailable {
            manager.request(baseURL + "activate-account",
                            method: .post,
                            parameters: ["email":email, "code": code],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil, nil)}
                                    
                                    if status == true {
                                        print("===--- USER ACTIVE SUCCESS ---===")
                                        guard let userResponse = apiResp["data"] as? [String: Any] else {return completion(false, nil, nil)}
                                    
                                        let user = UserManager.init(JSON: userResponse)
                                        
                                        completion(true, user, nil)
                                    } else {
                                        print("===--- USER ACTIVE  FAILED ---===")
                                        if let err = apiResp["errors"] as? [String] {
                                            completion(nil,nil, err)
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
                                    
                                    print("===---  USER ACTIVE FAILED ---===")
                                    completion(nil, nil,[error.localizedDescription])
                                }
                            }
        } else {
            completion(nil, nil,[AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    
    static func socialLogin (params: [String: Any], type: SocialLogin, action: SocialLoginAction, completion: @escaping (_ status: Bool?, _ userData: UserManager?,_ error: [String]?) -> Void) {
        if Network.isAvailable {
            var apiParams = params
            apiParams.updateValue(action.rawValue, forKey: "action")
            
            manager.request(baseURL + "social-login",
                            method: .post,
                            parameters: apiParams,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    guard let apiResp = data as? [String: Any], let status = apiResp["success"] as? Bool else {return completion(nil, nil, nil)}
                                    
                                    if status == true {
                                        print("===--- USER REGISTER SUCCESS ---===")
                                        guard let userResponse = apiResp["data"] as? [String: Any] else {return completion(false, nil, nil)}
                                    
                                        let user = UserManager.init(JSON: userResponse)
                                        
                                        completion(true, user, nil)
                                    } else {
                                        print("===--- USER REGISTER  FAILED ---===")
                                        if let err = apiResp["errors"] as? [String] {
                                            completion(nil,nil, err)
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("===---  USER REGISTER FAILED ---===")
                                    if response.response?.statusCode == 401 {
                                        UserManager.shared.deleteUser()
                                        if let welcomeBoard = R.storyboard.authentication.authNavigationController() {
                                            UIApplication.shared.windows.first?.rootViewController = welcomeBoard
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                                        }
                                    }
                                    completion(nil, nil,[error.localizedDescription])
                                }
                            }
        } else {
            completion(nil, nil,[AppStrings.getNetworkNotAvailableString()])
        }
        
    }
    
}
