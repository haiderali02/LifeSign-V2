//
//  UserData.swift
//  LifeSign
//
//  Created by Haider Ali on 16/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import ObjectMapper
import FBSDKLoginKit

class UserManager: Mappable {
    var user_id : Int = 0
    var first_name : String = ""
    var last_name : String = ""
    var email : String = ""
    var profil_Image: String = ""
    var language : String = ""
    var country_code : String = ""
    var phone_number : Int = 0
    var gender : String = ""
    var sos_number : Int = 0
    var sos_country_code: String = ""
    var blocked_Friends: Int = 0
    var zipcode : Int = 0
    var account_status : String = ""
    var user_status : String = ""
    var is_consent : Bool = false
    var is_newsletter : Bool = false
    var remove_ad : Bool = false
    var is_stranger_request : Bool = false
    var is_sound_on : Bool = false
    var timezone : String = ""
    var enable_autoclicks : Bool = false
    var access_token : String = ""
    var fcm_token : String = ""
    var provider: String = ""
    var game_points: Int = 0
    var userResources: UserResources?
    var userFriends: UserFriendS?

    static let shared = UserManager()
    
    init() {
        
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    
    func getUserFullName() -> String {
        return first_name + " " + last_name
    }
    
    func getUserPhoneNumber() -> String {
        return country_code + "\(phone_number)"
    }
    
    func getUserSOSNumber() -> String {
        return sos_country_code + "\(sos_number)"
    }
    
    func deleteUser() {
         user_id = 0
         first_name  = ""
         last_name  = ""
         email  = ""
         profil_Image = ""
         language  = ""
         country_code  = ""
         phone_number  = 0
         gender  = ""
         sos_number  = 0
         blocked_Friends = 0
         sos_country_code = ""
         zipcode  = 0
         game_points = 0
         account_status  = ""
         user_status  = ""
         is_consent  = false
         is_newsletter  = false
         remove_ad  = false
         is_stranger_request  = false
         is_sound_on  = false
         timezone  = ""
         enable_autoclicks  = false
         access_token  = ""
         
         fcm_token  = ""
         provider = ""
         userResources = nil
         userFriends = nil
        saveUser(user: self)
    }
    
    func loadUser() {
        let userDef = UserDefaults.standard
        if ((userDef.string(forKey: Constants.USER_DATA)) != nil) {
            let uString = UserDefaults.standard.value(forKey: Constants.USER_DATA) as! String
            let mapper = Mapper<UserManager>()
            let userObj = mapper.map(JSONString: uString)
            let map = Map.init(mappingType: .fromJSON, JSON: (userObj?.toJSON())!)
            self.mapping(map:map)
        }
        NotificationCenter.default.post(name: .reloadGameHeader, object: nil)
    }
    
    func saveUser(user:UserManager) {
        UserDefaults.standard.set(user.toJSONString()!, forKey: Constants.USER_DATA)
        UserDefaults.standard.synchronize()
        loadUser()
    }
    
    func isLoggedIn() -> Bool {
        return user_id > 0 ? true : false
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        language <- map["language"]
        country_code <- map["country_code"]
        phone_number <- map["phone_number"]
        gender <- map["gender"]
        sos_number <- map["sos_number"]
        zipcode <- map["zipcode"]
        account_status <- map["account_status"]
        game_points <- map["game_points"]
        user_status <- map["user_status"]
        is_consent <- map["is_consent"]
        is_newsletter <- map["is_newsletter"]
        remove_ad <- map["remove_ad"]
        is_stranger_request <- map["is_stranger_request"]
        is_sound_on <- map["is_sound_on"]
        timezone <- map["timezone"]
        profil_Image <- map["profile_image"]
        enable_autoclicks <- map["enable_autoclicks"]
        access_token <- map["access_token"]
        fcm_token <- map["fcm_token"]
        sos_country_code <- map["sos_country_code"]
        provider <- map["provider"]
        blocked_Friends <- map["blocked_Friends"]
        userFriends <- map["friends"]
        userResources <- map["resources"]
    }
}


class UserFriendS: Mappable {
    
    var general_friends: Int = 0
    var sos_friends: Int = 0
    var ok_send_friends: Int = 0
    var ok_receive_friends: Int = 0
    var daily_sign_friends: Int = 0
    
    
    init() {
        
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func mapping(map: Map) {
        general_friends <- map["general_friends"]
        sos_friends <- map["sos_friends"]
        ok_send_friends <- map["ok_send_friends"]
        ok_receive_friends <- map["ok_receive_friends"]
        daily_sign_friends <- map["daily_sign_friends"]
    }
}

class UserResources: Mappable {
    
    var message_contact: Int = 0
    var auto_clicked: Int = 0
    var game_contact: Int = 0
    var daily_sign_contact: Int = 0
    var total_sms: Int = 0
    var daily_sign_unlimited: Bool = false
    var game_contact_unlimited: Bool = false
    var message_contact_unlimited: Bool = false
    
    init() {
        
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func mapping(map: Map) {
        message_contact <- map["message_contact"]
        auto_clicked <- map["auto_clicked"]
        game_contact <- map["game_contact"]
        daily_sign_contact <- map["daily_sign_contact"]
        total_sms <- map["total_sms"]
        daily_sign_unlimited <- map["daily_sign_unlimited"]
        game_contact_unlimited <- map["game_contact_unlimited"]
        message_contact_unlimited <- map["message_contact_unlimited"]
    }
}


class UserCounters: Mappable {
    
    var bell: Int = 0
    var message: Int = 0
    var okTellFriend: Int = 0
    var daily_sign_friend: Int = 0
    var general_friend: Int = 0
    var sos_friend: Int = 0
    var sos_listing: Int = 0
    var sos: Int = 0
    var game_friend: Int = 0
    
    static let shared = UserCounters()
    
    init() {
        
    }
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func loadCounters() {
        let userDef = UserDefaults.standard
        if ((userDef.string(forKey: Constants.COUNTER_DATA)) != nil) {
            let uString = UserDefaults.standard.value(forKey: Constants.COUNTER_DATA) as! String
            let mapper = Mapper<UserCounters>()
            let counterObj = mapper.map(JSONString: uString)
            let map = Map.init(mappingType: .fromJSON, JSON: (counterObj?.toJSON())!)
            self.mapping(map:map)
        }
        // print("!- Counters Saved & Loaded -!")
    }
    
    func saveCounters(counters:UserCounters) {
        UserDefaults.standard.set(counters.toJSONString()!, forKey: Constants.COUNTER_DATA)
        UserDefaults.standard.synchronize()
        loadCounters()
    }
    
    
    func mapping(map: Map) {
        bell                <- map["bell"]
        sos_friend          <- map["sos_friend"]
        message             <- map["message"]
        sos_listing         <- map["sos_listing"]
        daily_sign_friend   <- map["daily_sign_friend"]
        okTellFriend        <- map["ok_tell_friend"]
        general_friend      <- map["general_friend"]
        sos                 <- map["sos"]
        game_friend         <- map["game_friend"]
    }
}


class SOSReceivedAlert: Mappable {
    
    var friend_id: Int = 0
    var full_name: String = ""
    var timezone: String = ""
    var profile_image: String = ""
    
    init() {
        
    }
    required init?(map: Map) {
        self.mapping(map: map)
    }
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func mapping(map: Map) {
        friend_id <- map["friend_id"]
        full_name <- map["full_name"]
        timezone <- map["timezone"]
        profile_image <- map["profile_image"]
    }
}


class LangObjectModel: Mappable {
    
    var image_circle: String = ""
    var image_rec: String = ""
    var name: String = ""
    var symbol: String = ""
    
    init() {
        
    }
    
    static let shared = LangObjectModel()
    
    func loadLanguage() {
        let userDef = UserDefaults.standard
        if ((userDef.string(forKey: Constants.SAVE_LANG)) != nil) {
            let uString = UserDefaults.standard.value(forKey: Constants.SAVE_LANG) as! String
            let mapper = Mapper<LangObjectModel>()
            let counterObj = mapper.map(JSONString: uString)
            let map = Map.init(mappingType: .fromJSON, JSON: (counterObj?.toJSON())!)
            self.mapping(map:map)
        }
        // print("!- Counters Saved & Loaded -!")
    }
    
    func saveLanguage(languages:LangObjectModel) {
        UserDefaults.standard.set(languages.toJSONString()!, forKey: Constants.SAVE_LANG)
        UserDefaults.standard.synchronize()
        loadLanguage()
    }

    
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func mapping(map: Map) {
        image_circle <- map["image_circle"]
        image_rec <- map["image_rec"]
        name <- map["name"]
        symbol <- map["symbol"]
    }
}


class OtherGamesModel: Mappable {
    
    var app_id: Int = 0
    var app_name: String = ""
    var app_url: String = ""
    var app_image: String = ""
    var ios_scheme: String = ""
    var is_reward: Bool = false
    
    init() {
        
    }
    required init?(map: Map) {
        self.mapping(map: map)
    }
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func mapping(map: Map) {
        app_id <- map["app_id"]
        app_name <- map["app_name"]
        app_url <- map["app_url"]
        app_image <- map["app_image"]
        ios_scheme <- map["ios_scheme"]
        is_reward <- map["is_reward"]
    }
}
