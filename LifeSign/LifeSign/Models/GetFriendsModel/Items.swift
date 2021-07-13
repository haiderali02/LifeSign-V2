

import Foundation
import ObjectMapper

struct Items : Mappable {
    var friend_request_id : Int = 0
    var user_id : Int = 0
    var friend_id: Int = 0
    var first_name : String = ""
    var last_name : String = ""
    var language : String = ""
    var timezone : String = ""
    var email : String = ""
    var fcm_token : String = ""
    var phone_number : String = ""
    var friend_status : String = ""
    var request_status : String = ""
    var profile_image : String = ""
    var sos_friend_status: String = ""
    var sos_request: String = ""
    var message: String = ""
    
    var provider: String = ""
    
    // DailySIgn
    var daily_sign_id: Int = 0
    var daily_sign_friend_request: String = ""
    var daily_sign_friend_status: String = ""
    var full_name: String = ""
    var current_datetime: String = ""
    var pint_datetime: String = ""
    var color_name_hex: String = ""
    var sign_request: String = ""
    var next_ping_datetime: String = ""
    
    // OkSIGN
    var agreement_id: Int = 0
    var agreement_friend_status: String = ""
    var is_read: Int = 0
    var initiator: Int = 0
    var agreement_next_time: String = ""
    var agreement_request: String = ""
    var agreement_dual: String = ""
    var remind_time: String = ""
    var read_reminder: Int = 0
    var agreement_status: String = ""
    
    // GAME
    var game_friend_status: String = ""
    var game_request: String = ""
    var remaining_time: String = ""
    var progress_games: UserGameProgress?
    var game_start_status: String = ""
    var game_winner: Int = 0
    var game_initiator: Int = 0
    
    var points: Int = 0
    var position: Int = 0
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

        friend_request_id <- map["friend_request_id"]
        user_id <- map["user_id"]
        friend_id <- map["friend_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        language <- map["language"]
        timezone <- map["timezone"]
        email <- map["email"]
        fcm_token <- map["fcm_token"]
        phone_number <- map["phone_number"]
        friend_status <- map["friend_status"]
        request_status <- map["request_status"]
        sos_request <- map["sos_request"]
        
        read_reminder <- map["read_reminder"]
        agreement_id <- map["agreement_id"]
        agreement_friend_status <- map["agreement_friend_status"]
        profile_image <- map["profile_image"]
        sos_friend_status <- map["sos_friend_status"]
        is_read <- map["is_read"]
        initiator <- map["initiator"]
        agreement_next_time <- map["agreement_next_time"]
        agreement_request <- map["agreement_request"]
        agreement_dual <- map["agreement_dual"]
        remind_time <- map["reminder_time"]
        
        message <- map["message"]
        full_name <- map["full_name"]
        daily_sign_id <- map["daily_sign_id"]
        daily_sign_friend_request <- map["daily_sign_friend_request"]
        daily_sign_friend_status <- map["daily_sign_friend_status"]
        current_datetime <- map["current_datetime"]
        pint_datetime <- map["pint_datetime"]
        color_name_hex <- map["color_name_hex"]
        sign_request <- map["sign_request"]
        next_ping_datetime <- map["next_ping_datetime"]
        
        provider <- map["provider"]
        
        agreement_status <- map["agreement_status"]
        game_friend_status <- map["game_friend_status"]
        game_request <- map["game_request"]
        remaining_time <- map["remaining_time"]
        progress_games  <- map["progress_games"]
        game_start_status <- map["game_start_status"]
        game_winner <- map["game_winner"]
        
        game_initiator <- map["game_initiator"]
        points <- map["points"]
        position <- map["position"]
        
	}
}


class UserGameProgress: Mappable {
    
    var click_by_user_id: Int = 0
    var friend_id: Int = 0
    var current_hit_time: String = ""
    var game_id: Int = 0
    var game_start_by_user_id: Int = 0
    var utc_time: String = ""
    
    
    var game_start_time: String = ""
    var hits: Int = 0
    var time: String = ""
    
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
        click_by_user_id <- map["click_by_user_id"]
        current_hit_time <- map["current_hit_time"]
        friend_id <- map["friend_id"]
        game_id <- map["game_id"]
        utc_time <- map["utc_time"]
        game_start_by_user_id <- map ["game_start_by_user_id"]
        game_start_time <- map ["game_start_time"]
        hits <- map["hits"]
        
        time <- map["time"]
    }
}
