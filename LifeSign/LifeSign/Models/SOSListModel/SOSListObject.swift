
import Foundation
import ObjectMapper

struct SOSListObject : Mappable {
	var sos_id : Int = 0
	var user_id : Int = 0
	var first_name : String = ""
	var last_name : String = ""
	var profile_image : String = ""
	var sos_name : String = ""
	var sos_read : Bool = false
	var sos_send_datetime : String = ""
	var sos_read_datetime : String = ""
	var sos_sender : Bool = false
    var provider: String = ""
    
	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		sos_id <- map["sos_id"]
		user_id <- map["user_id"]
		first_name <- map["first_name"]
		last_name <- map["last_name"]
		profile_image <- map["profile_image"]
		sos_name <- map["sos_name"]
		sos_read <- map["sos_read"]
		sos_send_datetime <- map["sos_send_datetime"]
		sos_read_datetime <- map["sos_read_datetime"]
		sos_sender <- map["sos_sender"]
        provider <- map["provider"]
	}

}
