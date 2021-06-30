

import Foundation
import ObjectMapper

struct NotificationResponse : Mappable {
	var success : Bool?
	var messages : String?
	var notificationData : NotificationData?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		success <- map["success"]
		messages <- map["messages"]
        notificationData <- map["data"]
	}

}
