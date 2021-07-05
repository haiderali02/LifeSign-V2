//
//  MKClockStatusModel.swift
//  Core Flow
//
//  Created by Apple on 12/02/2021.
//

import Foundation
class MKClockStatusModel: NSObject, MKAlarmClockStatusProtocol {
    var mondayIsOn: Bool = false
    var tuesdayIsOn: Bool = false
    var wednesdayIsOn: Bool = false
    var thursdayIsOn: Bool = false
    var fridayIsOn: Bool = false
    var saturdayIsOn: Bool = false
    var sundayIsOn: Bool = false
}

class MKConfigAlarmClockModel: NSObject, MKSetAlarmClockProtocol {
    var clockStatusProtocol: MKAlarmClockStatusProtocol?
    var index: Int = 0
    var time: String = ""
    var clockType: MKAlarmClockType = .normal
    var isOn: Bool = false
    
}
