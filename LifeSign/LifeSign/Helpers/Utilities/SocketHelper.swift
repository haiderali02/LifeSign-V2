//
//  SocketHelper.swift
//  Fastorder_Skeleton
//
//  Created by Taha Muneeb on 4/29/20.
//  Copyright © 2020 Taha Muneeb. All rights reserved.
//

import Foundation
import SocketIO
import LanguageManager_iOS

import UIKit

class SocketHelper {
    static let shared: SocketHelper = SocketHelper()
    let manager: SocketManager
    let socket: SocketIOClient
    
    private var subscribeClient = "subscribeClient"
    private var unSubscribeClient = "unsubscribeClient"
    
    private var updateMyOnlineStatusEvent = "lifesign_online_user"
    private var setUserOfflineEvent = "lifesign_user_offline"
    
    private var updateMyTypuingStatusEvent = "message_is_typing"
    
    private var getOnlineUserEvent = "user_online"
    private var getUpdateInboxEvent = "App_Events_MessageBroadCast:\(UserManager.shared.user_id)"
    
    private var messageTypingEvent = "message_is_typing"
    private var messageTypingStatusEvent = "message_is_typing:"
    
    private var messagesReadEvent = "App_Events_MessageRead:"
    
    
    private var notificationCounterEvent = "App_Events_NotificationCounter:"
    
    
    private var emitNotificationEvent = "notifications_events"
    private var listenNotificationEvent = "notifications_events:"
    
    private var emitGameStartEvent = "game_start"
    private var listenGameStartEvent = "game_start:"
    private var listenGameInvitEvent = "App_Events_GameEvent:"
    
    var dumoDataStr: String = ""
    
    init() {
        manager = SocketManager(socketURL: URL(string: Constants.socketIOURL)!, config: [.log(true), .compress, .extraHeaders(["Authorization": "Bearer" + " " + UserManager.shared.access_token])])
        socket = manager.defaultSocket
        socket.connect()
    }
    
    func establishConnection() {
        socket.on(clientEvent: .connect) { (_, _) in
            print(" ======------- Socekt Connected -------======")
            self.subscribe()
        }
        socket.on(clientEvent: .disconnect) { (_, _) in
            print("====================\nsocket disconnected\n====================")
        }
    }
    
    func subscribe() {
        if socket.status != .connected { return }
        var payload: [Any] = []
        
        payload.append(LangObjectModel.shared.symbol ?? "en")
        socket.emitWithAck(subscribeClient, payload).timingOut(after: 10) { (data) in
            // print("====================\nSocket Data:\n\(data)\n====================")
        }
        
        if UserManager.shared.isLoggedIn() {
            self.updateUserOnlineStatus()
        }
        
        socket.on(getOnlineUserEvent) { (data, _) in
            // print("====================\nSocket Data:\n\(data)\n====================")
            guard let users = data.first as? NSString else {return}
            
            let newUser: String = users as String
            
            let data = newUser.data(using: .utf8)
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [Any]
                {
                    if let arr = jsonArray as? [Int] {
                        NotificationCenter.default.post(name: .getOnlineLatestUsers, object: arr)
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        socket.on(getUpdateInboxEvent) { (data, _) in
            //  print("====================\nSocket Data:\n\(data)\n====================")
            
            for items in data {
                
                guard let response = items as? [String: Any],
                      let responseData = response["data"] as? [String: Any],
                      let counters = responseData["counters"] as? [String: Any],
                      let inbox = counters["inbox"] as? [String: Any],
                      let inboxItems = inbox["items"] as? [Any],
                      let lastMessage = counters["message"] as? [String: Any]
                
                else {return}
                
                
                let latestData = [
                    "inbox": inboxItems,
                    "latestMessage": lastMessage
                ] as [String : Any]
                
                NotificationCenter.default.post(name: .getInboxLatestData, object: latestData)
                
                print("SOCKET:- Inbox Items: \(inboxItems)")
                print("SOCKET:- LAST MESSAGE: \(lastMessage)")
                
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("...Hit Now...")
            self.emitNotificationEventToSocket()
        }
        
        self.listenGameInvitationEvent { items in
            print("Wahhaa")
        }
        
    }
    
    
    func getMyFriendISTypingStatus(friendID: Int, completion: @escaping (_ onlineUsers: [Int]?) -> Void) {
        socket.on("message_is_typing:\(friendID)") { (data, _) in
            // print("====================\nSocket Data:\n\(data)\n====================")
            if let users = data[0] as? [Int] {
                print("Users: \(users)")
            }
        }
    }
    
    func getAllOnlineUsers(completion: @escaping (_ onlineUsers: [Int]?) -> Void) {
        socket.on(getOnlineUserEvent) { (data, _) in
            // print("====================\nSocket Data:\n\(data)\n====================")
            if let _ = data[0] as? [Int] {
                // print("Users: \(users)")
            }
        }
    }
    
    func getUserLatestDataAndCounters(completion: @escaping ( _ sosAlerts: [SOSReceivedAlert]?) -> Void) {
        socket.on(notificationCounterEvent + "\(UserManager.shared.user_id)") { (data, _) in
            // print("====================\nSocket Data:\n\(data)\n====================")
            var sosAlerts = [SOSReceivedAlert]()
            for items in data {
                
                guard let response = items as? [String: Any],
                      let data = response["data"] as? [String: Any],
                      let counterr = data["counters"] as? [String: Any],
                      let allNotifications = counterr["all_notifications"] as? [String: Any],
                      let currentUser = counterr["user"] as? [String: Any],
                      let sos_alerts = counterr["sos_alert"] as? [Any]
                else {return}
                
                
                let updatedUser = UserManager.init(dic: currentUser)
                UserManager.shared.saveUser(user: updatedUser)
                
                
                let userCounters = UserCounters.init(dic: allNotifications)
                UserCounters.shared.saveCounters(counters: userCounters)
                
                for obj in sos_alerts {
                    let sosAlert = SOSReceivedAlert.init(dic: obj as! [String: Any])
                    sosAlerts.append(sosAlert)
                }
                
                completion(sosAlerts)
                
            }
        }
    }
    
    func setMessagesRead(friendID: Int, completion: @escaping (_ readMessages: [Any]) -> Void){
        
        socket.on(messagesReadEvent + "\(friendID)") { (data, _) in
            // print("====================\nSocket Data:\n\(data)\n====================")
            
            for items in data {
                
                guard let response = items as? [String: Any],
                      let responseData = response["data"] as? [String: Any],
                      let counters = responseData["counters"] as? [Any]
                else {return}
                completion(counters)
            }
        }
    }
    
    func getFriendTypingStatus(completion: @escaping (_ isTyping: Bool?) -> Void) {
        socket.on(messageTypingStatusEvent + "\(UserManager.shared.user_id)") { (data, _) in
            // print("====================\nSocket Data:\n\(data)\n====================")
            guard let socketData = data.first as? NSString else {return}
            let typingData: String = socketData as String
            let data = typingData.data(using: .utf8)
            do {
                if let statusDictionary = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [String: Any]
                {
                    guard let isTyping = statusDictionary["is_typing"] as? Bool else {return}
                    completion(isTyping)
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func updateTypingStatus(friend_id: Int, is_typing: Bool) {
        socket.emit(messageTypingEvent, with: [["friend_id":friend_id, "is_typing": is_typing, "user_id": UserManager.shared.user_id]])
    }
    
    func updateUserOnlineStatus() {
        socket.emit(updateMyOnlineStatusEvent, with: [["user_id":UserManager.shared.user_id]])
        
        listenNotificationEventFromSocket { data in
            NotificationCenter.default.post(name: .getSOSReceiveds, object: ["sosReceived" : data])
        }
        
        listenGameStartEvent { _  in
            
        }
        
    }
    
    
    func emitNotificationEventToSocket() {
        
        socket.emit(emitNotificationEvent, with: [["user_id":UserManager.shared.user_id]])
    }
    
    func listenNotificationEventFromSocket(completion: @escaping ( _ sosAlerts: [SOSReceivedAlert]?) -> Void) {
        socket.on(listenNotificationEvent + "\(UserManager.shared.user_id)") { (data, _) in
            print("====================\nSocket Data:\n\(data)\n====================")
            var sosAlerts = [SOSReceivedAlert]()
            guard let socketData = data.first as? NSString else {return}
            let jsonString: String = socketData as String
            let jsonStringData = jsonString.data(using: .utf8)
            
            do {
                if let statusDictionary = try JSONSerialization.jsonObject(with: jsonStringData!, options : .allowFragments) as? [String: Any]
                {
                    guard let responseData = statusDictionary["data"] as? [String: Any],
                          let counterr = responseData["counters"] as? [String: Any],
                          let allNotifications = counterr["all_notifications"] as? [String: Any],
                          let currentUser = counterr["user"] as? [String: Any],
                          let sos_alerts = counterr["sos_alert"] as? [Any]
                    else {return}
                    
                    
                    
                    let updatedUser = UserManager.init(dic: currentUser)
                    UserManager.shared.saveUser(user: updatedUser)
                    
                    
                    let userCounters = UserCounters.init(dic: allNotifications)
                    UserCounters.shared.saveCounters(counters: userCounters)
                    NotificationCenter.default.post(name: .refreshData, object: nil)
                    for obj in sos_alerts {
                        let sosAlert = SOSReceivedAlert.init(dic: obj as! [String: Any])
                        sosAlerts.append(sosAlert)
                    }
                    
                    completion(sosAlerts)
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
    }
    
    func updateMessageTypingStatus(friend_ID: Int, isTyping: Bool) {
        socket.emit(updateMyTypuingStatusEvent, with: [["friend_id":friend_ID, "is_typing": isTyping]])
    }
    
    func sendGameStartEvent(gameID: Int, clickByUser_id: Int, startUserId: Int, friendID: Int, gameStartTime: String, fcmTokken: String, message: String) {
        socket.emit(emitGameStartEvent, with: [["game_id": gameID, "click_by_user_id": clickByUser_id, "start_user_id" : startUserId ,"friend_id": friendID, "game_start_time": gameStartTime, "fcm_token": fcmTokken, "message": message]])
    }
    
    
    func listenGameStartEvent(completion: @escaping ( _ gameProgressObject: UserGameProgress?) -> Void) {
        socket.on(listenGameStartEvent + "\(UserManager.shared.user_id)") { (data, _) in
            print("====================\nSocket Data:\n\(data)\n====================")
            
            guard let socketData = data.first as? NSString else {return}
            let jsonString: String = socketData as String
            let jsonStringData = jsonString.data(using: .utf8)

            do {
                if let statusDictionary = try JSONSerialization.jsonObject(with: jsonStringData!, options : .allowFragments) as? [String: Any]
                {
                    
                    let gameObj = UserGameProgress(JSON: statusDictionary)
                    completion(gameObj)
                    
                } else {
                    print("bad json")
                    completion(nil)
                }
            } catch let error as NSError {
                print(error)
                completion(nil)
            }
        
        }
    }
    
    func listenGameInvitationEvent(completion: @escaping ( _ gameFriends: [Items]?) -> Void) {
        socket.on(listenGameInvitEvent + "\(UserManager.shared.user_id)") { (data, _) in
            print("====================\nSocket Data:\n\(data)\n====================")
            
            var userGameFrnd: [Items] = [Items]()
            
            for items in data {
                
                guard let response = items as? [String: Any],
                      let responseData = response["data"] as? [String: Any],
                      let counters = responseData["counters"] as? [String: Any],
                      let allGameFriends = counters["items"] as? [Any]
                else {return}
                
                for obj in allGameFriends {
                    if let gameFriend = obj as? [String: Any] {
                        if let itemObj = Items(JSON: gameFriend) {
                            if let progressGame = itemObj.progress_games {
                                if progressGame.game_id == 0 {
                                    Helper.removeFrineObjectFromLocal(friend_id: itemObj.friend_id)
                                }
                            }
                            userGameFrnd.append(itemObj)
                        }
                    }
                }
                
                
                completion(userGameFrnd)
                
            }
            
        }
    }
    
    
    func setUserOffline() {
        socket.emit(setUserOfflineEvent, with: [["user_id":UserManager.shared.user_id]])
    }
    
    func unSubscribe() {
        if socket.status != .connected { return }
        socket.emitWithAck(unSubscribeClient).timingOut(after: 10) { _ in
            print("====================\nSocket unsubcribed\n====================")
        }
    }
    
    func closeConnection() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("===--- Socket Disconnected ---===")
    }
    
}
