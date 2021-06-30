
import Foundation
import ObjectMapper

struct SOSListingResponse : Mappable {
	var success : Bool?
	var messages : String?
	var sosListData : SOSListData?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		success <- map["success"]
		messages <- map["messages"]
        sosListData <- map["data"]
	}

}
