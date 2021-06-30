

import Foundation
import ObjectMapper

struct SOSListData : Mappable {
	var sos_listing : [SOSListObject]?
	var links : Links?

	init?(map: Map) {

	}
	mutating func mapping(map: Map) {
		sos_listing <- map["sos_listing"]
		links <- map["links"]
	}
}
