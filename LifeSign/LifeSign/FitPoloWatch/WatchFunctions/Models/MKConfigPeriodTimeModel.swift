//
//  MKConfigPeriodTimeModel.swift
//  Core Flow
//
//  Created by Apple on 12/02/2021.
//

import Foundation

class MKConfigPeriodTimeModel: NSObject, MKPeriodTimeSetProtocol {
    var startHour: Int = 0
    var startMin: Int = 0
    var endHour: Int = 0
    var endMin: Int = 0
    var isOn: Bool = false
}
