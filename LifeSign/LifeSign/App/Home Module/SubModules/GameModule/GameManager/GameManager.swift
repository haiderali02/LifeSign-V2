//
//  GameManager.swift
//  LifeSign
//
//  Created by Haider Ali on 31/05/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Alamofire
import LanguageManager_iOS

struct GameManager {
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

extension GameManager {
    
    //
    // MARK: - GET USER GAME FRIENDS -
    //
    
    static func getMYGameFriends(searchString: String?, limit: Int?, PageNumber: Int?, _ completion: @escaping (_ lifeSinUsers: FriendsData?, _ game_countact: Int?, _ error: [String]?, _ links: Links?) -> Void) {
        if Network.isAvailable {
            var params = [
                "limit": limit ?? 10,
                "page": PageNumber ?? 1
            ] as [String : Any]
            if let searchQuery = searchString {
                params.updateValue(searchQuery, forKey: "search")
            }
            
            manager.request(baseURL + "game/friends",
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
                                                completion(friendsRrsponse?.data, friendsRrsponse?.game_contact,nil, friendsRrsponse?.data?.links)
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
    
    
    //
    // MARK: - REMOVE GAME FRIEND -
    //
    
    
    static func removeGameFriend(friendID: Int, _ completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            manager.request(baseURL + "game/delete-game",
                            method: .post,
                            parameters: ["friend_id":friendID],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("Friend Remove Data \(data)")
                                        if success {
                                            if let userData = response["data"] as? [String: Any] {
                                                if let newUser = UserManager(JSON: userData) {
                                                    UserManager.shared.saveUser(user: newUser)
                                                }
                                            }
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
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    //
    // MARK: - ENABLE AUTO CLICKS -
    //
    
    
    static func enableAutoClicks(enableClics: Int, _ completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            manager.request(baseURL + "game/enabled-click",
                            method: .post,
                            parameters: ["enabled_click":enableClics],
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("AUTOCLICKS \(data)")
                                        if success {
                                            if let userData = response["data"] as? [String: Any] {
                                                if let newUser = UserManager(JSON: userData) {
                                                    UserManager.shared.saveUser(user: newUser)
                                                }
                                            }
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
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    //
    // MARK: - Watch Video and Earn Reward -
    //
    
    
    static func earnReward(rewardType: String, app_id: Int = 0,_ completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            var params = ["category":rewardType] as [String: Any]
            
            if app_id != 0 {
                params["app_id"] = app_id
            }
            
            manager.request(baseURL + "shop/view-ads",
                            method: .post,
                            parameters: params,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("AUTOCLICKS \(data)")
                                        if success {
                                            if let userData = response["data"] as? [String: Any] {
                                                if let newUser = UserManager(JSON: userData) {
                                                    UserManager.shared.saveUser(user: newUser)
                                                }
                                            }
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
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    
    //
    // MARK: - SEND GAME FRIEND REQUEST -
    //
    
    
    static func sendGameFriendRequest(friend_ID: Int, _ completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            manager.request(baseURL + "game/send-game-friend-request",
                            method: .post,
                            parameters: ["friend_id":friend_ID],
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
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    
    //
    // MARK: - GET LEADERBOARD -
    //
    
    
    
    static func getLeaderBoaed( _ completion: @escaping (_ top100UsersList: [Any]?, _ myFriendsList: [Any]?, _ error: [String]?, _ links: Links?) -> Void) {
        if Network.isAvailable {
            
            manager.request(baseURL + "game/rankings",
                            method: .get,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    print("Print: \(data)")
                                    
                                    if let response = data as? [String: Any] {
                                    
                                        if let responseStats = response["success"] as? Bool {
                                            if responseStats == true {
                                                // Get Data here
                                                
                                                guard let records = response["data"] as? [String: Any],
                                                      let word100Users = records["worlds"] as? [Any],
                                                      let myFriends = records["friends"] as? [Any]
                                                      else {return}
                                                
                                                completion(word100Users, myFriends, nil, nil)
                                                
                                            } else {
                                                if let errors = response["errors"] as? [String] {
                                                    completion(nil, nil, errors, nil)
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
                                        completion(nil, nil, [AppStrings.getSomwthingWentWrong()], nil)
                                    }
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
            
        } else {
            completion(nil, nil, [AppStrings.getNetworkNotAvailableString()], nil)
        }
    }
    
    
    //
    // MARK: - GET ALL OTHER APPS -
    //
    
    
    static func getAllOtherApps(_ completion: @escaping (_ otherGames: [OtherGamesModel]?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            manager.request(baseURL + "shop/download-apps",
                            method: .post,
                            parameters: nil,
                            headers: authHeaders).validate().responseJSON { (response) in
                                switch response.result {
                                case .success(let data):
                                    if let response = data as? [String: Any], let success = response["success"] as? Bool {
                                        print("Apps Loaded \(data)")
                                        if success {
                                            
                                            guard let apiData = response["data"] as? [String: Any],
                                                  let gameObjects = apiData["items"] as? [Any]
                                            else {return}
                                            
                                            var games = [OtherGamesModel]()
                                            
                                            gameObjects.forEach { obj in
                                                if let game = OtherGamesModel(JSON: obj as! [String: Any]) {
                                                    games.append(game)
                                                }
                                            }
                                            
                                            completion(games, nil)
                                            
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
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    
    //
    // MARK: - SEND GAME REQUEST TO REQUEST -
    //
    
    
    static func sendGameRequestToFriend(friend_ID: Int, _ completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            
            manager.request(baseURL + "game/sent-game-request",
                            method: .post,
                            parameters: ["friend_id":friend_ID],
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
            completion(nil, [AppStrings.getNetworkNotAvailableString()])
        }
    }
    
    ///
    // MARK:- ACCEPT REJECT GAME REQUEST FROM FRIEND -
    ///
    
    static func acceptRejectGameRequestFromFriend (friendID: Int, gameRequestStatus: String, _ completion: @escaping (_ lifeSinUsers: FriendsData?, _ error: [String]?, _ links: Links?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id"    :   friendID,
                "status"       :   gameRequestStatus
            ] as [String : Any]
            manager.request(baseURL + "game/accept-game-request",
                            method: .post,
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
    // MARK:- ACCEPT REJECT GAME FRIEND REQUEST -
    ///
    
    static func acceptRejectGameFriendRequest (friendID: Int, gameRequestStatus: String, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "friend_id"         :   friendID,
                "game_status"       :   gameRequestStatus
            ] as [String : Any]
            manager.request(baseURL + "game/accept-or-reject-game-friend-request",
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
    // MARK:- END RUNNING GAME -
    ///
    
    static func endGameAndDecideWinner (game_id: Int, winner_user_id: Int, completion: @escaping (_ status: Bool?, _ error: [String]?) -> Void) {
        if Network.isAvailable {
            let params = [
                "game_id"         :   game_id,
                "winner_user_id"       :   winner_user_id
            ] as [String : Any]
            manager.request(baseURL + "game/end-game",
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
    
}
