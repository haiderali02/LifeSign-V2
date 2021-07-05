//
//  MKConfigInterface.swift
//  Core Flow
//
//  Created by Apple on 12/02/2021.
//

import Foundation

class MKConfigInterface {
    
    typealias completion = (Any?) -> Void
    typealias failure = (String) -> Void
    
    // MARK:- CONFIG ANCS NOTICE -
    
    static func configANCSNotice(success: @escaping completion, failure: @escaping failure)  {
        let ansModel = MKAncsModel()
        ansModel.openQQ = true
        ansModel.openFacebook = true
        ansModel.openPhone = true
        ansModel.openSMS = true
        
        MKDeviceInterface.configANCSNotice(ansModel) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configANCSNotice")
        }
    }
    
    // MARK:- CONFIG ALARM ALARM -
    
    static func configAlarmClock(time: String = "20:15",success: @escaping completion, failure: @escaping failure)  {
        
        let statusModel = MKClockStatusModel()
        statusModel.mondayIsOn = true
        statusModel.fridayIsOn = true
        statusModel.saturdayIsOn = true
        statusModel.tuesdayIsOn = true
        statusModel.wednesdayIsOn = true
        
        let clockModel = MKConfigAlarmClockModel()
        clockModel.time = time
        clockModel.clockType = .sport
        clockModel.clockStatusProtocol = statusModel
        
        MKDeviceInterface.configAlarmClock([clockModel]) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configAlarmClock")
        }
    }
    
    // MARK:- Sadentry Reminder -
    
    static func configureSadentryReminder(success: @escaping completion, failure: @escaping failure)  {
        
        let timeModel = MKConfigPeriodTimeModel()
        timeModel.isOn = true
        timeModel.startHour = 1
        timeModel.startMin = 1
        timeModel.endHour = 10
        timeModel.endMin = 10
        
        MKDeviceInterface.configSedentaryRemind(timeModel) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configSedentaryRemind")
        }
    }
    
    // MARK:- Heart Rate Acquisition Interval -
    
    static func configureHeartRateAcquisionInterval(success: @escaping completion, failure: @escaping failure)  {
        MKDeviceInterface.configHeartRateAcquisitionInterval(.interval10Min) { (data) in
            print("Config Data: Heart Acqu \(data ?? "")")
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configureHeartRateAcquisionInterval")
        }
    }
        
    // MARK:- Configure Palm Bright Screen -
    
    static func configPalmingBrightScreen(success: @escaping completion, failure: @escaping failure)  {
        
        let timeModel = MKConfigPeriodTimeModel()
        timeModel.isOn = true
        timeModel.startHour = 1
        timeModel.startMin = 1
        timeModel.endHour = 10
        timeModel.endMin = 10
        
        MKDeviceInterface.configPalmingBrightScreen(timeModel) { (data) in
            print("Config Data: configPalmingBrightScreen \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configPalmingBrightScreen")
        }
    }
    
    // MARK:- Configure Light Brightness Display -
    
    static func configRemindLastScreenDisplay(config: Bool = true,success: @escaping completion, failure: @escaping failure)  {
        MKDeviceInterface.configRemindLastScreenDisplay(config) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configRemindLastScreenDisplay")
        }
    }
    
    // MARK:- Config Custom Screen Display -
    
    static func configCustomScreenDisplay(config: Bool = true,success: @escaping completion, failure: @escaping failure)  {
        
        let model = MKCustomScreenDisplayModel()
        model.turnOnStepPage = true
        model.turnOnHeartRatePage = true
        model.turnOnSportsDistancePage = true
        
        MKDeviceInterface.configCustomScreenDisplay(model) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configCustomScreenDisplay")
        }
    }
    
    // MARK:- Cnfig Device Date -
    
    static func configDate(success: @escaping completion, failure: @escaping failure)  {
        let formattor = DateFormatter()
        formattor.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let dateString = formattor.string(from: Date())
        let dateList = dateString.components(separatedBy: "-")
        let model = MKConfigDateModel()
        model.year = Int(dateList[0])!
        model.month = Int(dateList[1])!
        model.day = Int(dateList[2])!
        model.hour = Int(dateList[3])!
        model.minutes = Int(dateList[4])!
        model.seconds = Int(dateList[5])!
        MKUserDataInterface.configDate(model) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configDate")
        }
    }
    
    
    // MARK:- Config User Data -
    
    
    static func configUserData(weight: Int, height: Int, age: Int,gender: mk_fitpoloGender ,success: @escaping completion, failure: @escaping failure)  {
        let model = MKConfigUserDataModel()
        model.weight = weight
        model.height = height
        model.gender = gender
        model.userAge = age
        MKUserDataInterface.configUserData(model) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configUserData")
        }
    }
    
    
    // MARK:- Config do not disturb mode -
    
    static func configDonotDisturb(success: @escaping completion, failure: @escaping failure)  {
        let timeModel = MKConfigPeriodTimeModel()
        timeModel.isOn = true
        timeModel.startHour = 1
        timeModel.startMin = 1
        timeModel.endHour = 10
        timeModel.endMin = 10
        MKDeviceInterface.configDoNotDisturbMode(timeModel) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configDoNotDisturbMode")
        }
    }
    
    // MARK:- Config Step Change -
    
    static func configStepChangeMeterMonitoringState(success: @escaping completion, failure: @escaping failure)  {
        MKUserDataInterface.configStepChangeMeterMonitoringState(true) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configStepChangeMeterMonitoringState")
        }
    }
    
    // MARK:- Config Moving Target -
    
    static func configMovingTarget(success: @escaping completion, failure: @escaping failure)  {
        MKUserDataInterface.configMovingTarget(1000) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configMovingTarget")
        }
    }
    
    // MARK:- Config Meter Step Intervel -
    
    static func configMeterStepInterval(success: @escaping completion, failure: @escaping failure)  {
        MKUserDataInterface.configMeterStepInterval(30) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configMeterStepInterval")
        }
    }
    
    // MARK:- Config Search Phone -
    
    static func configSearchPhone(success: @escaping completion, failure: @escaping failure)  {
        MKUserDataInterface.configSearchPhone(true) { (data) in
            print("Config Data: \(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to configSearchPhone")
        }
    }
}
