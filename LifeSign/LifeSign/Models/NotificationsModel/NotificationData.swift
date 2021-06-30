

import Foundation
import ObjectMapper

struct NotificationData : Mappable {
	var notifications : [Notifications] = [Notifications]()
	var links : Links?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		notifications <- map["notifications"]
		links <- map["links"]
	}

}
