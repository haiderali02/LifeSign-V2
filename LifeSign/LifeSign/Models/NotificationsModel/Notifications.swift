

import Foundation
import ObjectMapper


extension String {
    
    static let dailySignType = "daily_sign"
    static let dailySignAccept = "daily_sign_accept"
    static let dailySignSwap = "daily_sign_swap"
    static let dailySignUpdateTime = "daily_sign_update_time"
    static let dailySignI_am_safe = "daily_sign_i_am_safe"
    static let dailySignRequest = "daily_sign_request"
    
    static let okSignAgreement = "agreement"
    static let okAgreementReminder = "agreement_reminder"
    static let okAgreementI_am_ok = "agreement_i_am_ok"
    static let okAgreementRequest = "agreement_request"
    static let okAgreementAccept = "agreement_accept"
    
    static let sosType = "sos"
    static let sosRequest = "sos_request"
    static let sosAccept = "sos_accept"
    static let sosAlert = "sos_alert"
    
    static let generalFriendType = "general"
    static let generalFriendRequest = "friend_request"
    static let generalFriendAccept = "accept_request"
    
    static let gameType = "game"
    static let shopType = "shop"
    static let shopSMS = "shop_sms"
    
}


struct Notifications : Mappable {
	var notification_id : Int = 0
	var type : String = ""
	var sub_type : String = ""
	var full_name : String = ""
	var status : Int = 0
	var message : String = ""
	var profile_image : String = ""
	var created_at : String = ""

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		notification_id <- map["notification_id"]
		type <- map["type"]
		sub_type <- map["sub_type"]
		full_name <- map["full_name"]
		status <- map["status"]
		message <- map["message"]
		profile_image <- map["profile_image"]
		created_at <- map["created_at"]
	}

}
