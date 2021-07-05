//
//  MKDateTimeModel.swift
//  Core Flow
//
//  Created by Apple on 12/02/2021.
//

import Foundation

class MKReadDataTimeModel: NSObject, MKReadDeviceDataTimeProtocol {
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var hour: Int = 0
    var minutes: Int = 0
}

class MKConfigDateModel: MKReadDataTimeModel, MKConfigDateProtocol {
    var seconds: Int = 0
}
