//
//  InboxFriendModel.swift
//  LifeSign
//
//  Created by Haider Ali on 21/05/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import ObjectMapper


struct InboxBaseResponse : Mappable {
    var success : Bool = false
    var messages : String = ""
    var current_user_id : Int = 0
    var inboxBaseData : InboxBaseData?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        success <- map["success"]
        messages <- map["messages"]
        current_user_id <- map["current_user_id"]
        inboxBaseData <- map["data"]
    }

}


struct ChatBaseResponse : Mappable {
    var success : Bool = false
    var messages : String = ""
    var current_user_id : Int = 0
    var is_promotion: Bool = false
    var is_buy_package: Bool = false
    var chatBaseData : ChatBaseData?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        success <- map["success"]
        messages <- map["messages"]
        is_promotion <- map["is_promotion"]
        is_buy_package <- map["is_buy_package"]
        current_user_id <- map["current_user_id"]
        chatBaseData <- map["data"]
    }

}

struct ChatBaseData : Mappable {
    var chatMessages : [InboxMessageModel]?
    var links : Links?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        chatMessages <- map["items"]
        links <- map["links"]
    }

}


struct InboxBaseData : Mappable {
    var friends : InboxFriend?
    var messages : InboxMessage?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        friends <- map["friends"]
        messages <- map["messages"]
    }

}

struct InboxFriend : Mappable {
    var inboxFriends : [InboxFriendModel]?
    var links : Links?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        inboxFriends <- map["items"]
        links <- map["links"]
    }

}

struct InboxMessage : Mappable {
    var inboxMessages : [InboxMessageModel]?
    var links : Links?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        inboxMessages <- map["items"]
        links <- map["links"]
    }

}

struct InboxFriendModel : Mappable {
    
    var friend_id: Int = 0
    var is_online: Bool = false
    var profile_image: String = ""
    var full_name: String = ""
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        friend_id <- map["friend_id"]
        is_online <- map["is_online"]
        profile_image <- map["profile_image"]
        full_name <- map["full_name"]
    }
}


struct InboxMessageModel : Mappable {
    
    var message_id : Int = 0
    var message : String = ""
    var sent_at : String = ""
    var attachment: String = ""
    var is_read : Bool = false
    var is_sent : Bool = false
    var user_id : Int = 0
    var utc_sent_at: String = ""
    var is_online : Bool = false
    var full_name : String = ""
    var profile_image : String = ""
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message_id <- map["message_id"]
        message <- map["message"]
        sent_at <- map["sent_at"]
        attachment <- map["attachment"]
        utc_sent_at <- map["utc_sent_at"]
        is_read <- map["is_read"]
        is_sent <- map["is_sent"]
        user_id <- map["user_id"]
        is_online <- map["is_online"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
    }
}
