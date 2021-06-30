

import Foundation
import ObjectMapper

struct FriendsResponse : Mappable {
	var success : Bool?
	var messages : String?
	var data : FriendsData?
    var game_contact: Int = 0
    var dailySignContacts: Int = 0
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		success <- map["success"]
		messages <- map["messages"]
		data <- map["data"]
        game_contact <- map["game_contacts"]
        dailySignContacts <- map["daily_sign_contacts"]
	}
}
