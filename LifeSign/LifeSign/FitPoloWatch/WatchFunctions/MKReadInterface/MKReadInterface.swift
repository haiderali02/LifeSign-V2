//
//  MKReadInterface.swift
//  Core Flow
//
//  Created by Apple on 12/02/2021.
//

import Foundation

class MKReadInterface {
    typealias completion = (Any?) -> Void
    typealias failure = (String) -> Void
    
    ///
    // MARK:- READ BATTERY STATE -
    ///
    static func readWatchBatteryInfo(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readBattery { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Battery Status")
        }
    }
    
    ///
    // MARK:- READ FIRM VERION STATE -
    ///
    static func readFirmareVersion(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readFirmwareVersion { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Firmare version")
        }
    }
    
    ///
    // MARK:- READ HARDWARE PARAMERTER -
    ///
    static func readHardwareParameter(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readHardwareParameters { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Hardware Params")
        }
    }
    
    ///
    // MARK:- READ LAST CHARGING TIME -
    ///
    static func readLastChargingTime(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readLastChargingTime { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Last Charging Time")
        }
    }
    
    ///
    // MARK:- READ UNIT -
    ///
    static func readUnit(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readUnit { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Units")
        }
    }
    
    ///
    // MARK:- READ ANCS CONNECTION STATUS -
    /// ancs connection status
    static func readANCSconnectionStatus(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readAncsConnectStatus { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read ANCS connection status")
        }
    }
    ///
    // MARK:- READ ANCS OPTION STATUS -
    /// ancs option status
    static func readANCSOptionStatus(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readAncsOptions { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read ANCS option status")
        }
    }
    
    ///
    // MARK:- READ ALARM CLOCK DATES -
    ///
    static func readAlarmClockDatas(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readAlarmClockDatas { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read alarm clock datas")
        }
    }
    
    ///
    // MARK:- REMIND LAST SCREEN DISPLAY -
    ///
    static func remindLastScreenDisplay(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readRemindLastScreenDisplay { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readRemindLastScreenDisplay")
        }
    }
    
    ///
    // MARK:- READ DIAL STYLE -
    ///
    
    static func readDialStyleData(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readDialStyle { (data) in
            print("*** readDialStyle Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read readDialStyle")
        }
    }
    
    ///
    // MARK:- READ CUSTOM SCREEN DISPLAY -
    ///
    static func readCustomScreenDisplayWithSucBlock(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readCustomScreenDisplay { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readCustomScreenDisplay")
        }
    }
    
    ///
    // MARK:- READ TIME FORMAT -
    ///
    static func readConnectStatus(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readTimeFormat { (data) in
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Time Format")
        }
    }
    
    ///
    // MARK:- READ DATE FORMAT -
    ///
    static func readDateFormatterWithSucBlock(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readDateFormatter { (data) in
            print("*** readDateFormatter Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readDateFormatter")
        }
    }
    
    /// *************** USER STATS ******************
    
    ///
    // MARK:- READ PALM BRIGHT -
    /// Turn your wrist to light up the screen
    
    static func readPalmingBrighScreen(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readPalmingBrightScreen { (data) in
            print("*** readPalmingBrighScreen Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Palm Brightness")
        }
    }
    
    ///
    // MARK:- HEART RATE COLLECTION INTERVAL -
    /// Heart rate collection interval

    static func readHeartBeatAccquisionInterval(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readHeartRateAcquisitionInterval { (data) in
            print("*** Heart Rate collection interval Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Heart rate collection Interval")
        }
    }
    
    ///
    // MARK:- READ SENDETRY REMINDER -
    /// Sedentary reminder
    
    static func readSendatryReminder(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readSedentaryRemind { (data) in
            print("*** readSedentaryRemind Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Sedentary reminder")
        }
    }
    
    ///
    // MARK:- READ USER STEP COUNT -
    ///
    
    static func readStepData(success: @escaping completion, failure: @escaping failure) {
        
        let timeModel = MKReadDataTimeModel()
        timeModel.year = 2000
        timeModel.month = 1
        timeModel.day = 1
        timeModel.hour = 1
        timeModel.minutes = 1
        
        MKUserDataInterface.readStepData(withTimeStamp: timeModel) { (data) in
            print("*** Step Count Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readStepDataWithTimeStamp")
        }
    }
    
    ///
    // MARK:- READ USER SLEEP INTERVALS -
    ///
    
    static func readSleepData(success: @escaping completion, failure: @escaping failure) {
        
        let timeModel = MKReadDataTimeModel()
        timeModel.year = 2000
        timeModel.month = 1
        timeModel.day = 1
        timeModel.hour = 1
        timeModel.minutes = 1
        
        MKUserDataInterface.readSleepData(withTimeStamp: timeModel) { (data) in
            print("*** Sleep Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readSleepData")
        }
    }
    
    ///
    // MARK:- READ USER HEART RATES -
    ///
    
    static func readHeartData(success: @escaping completion, failure: @escaping failure) {
        
        let timeModel = MKReadDataTimeModel()
        timeModel.year = 2020
        timeModel.month = 1
        timeModel.day = 1
        timeModel.hour = 1
        timeModel.minutes = 1
        
        MKUserDataInterface.readHeartData(withTimeStamp: timeModel) { (data) in
            print("*** HEART Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readHeartData")
        }
    }
    
    ///
    // MARK:- READ USER DO NOT DISTURB -
    ///
    
    static func readDonotDisturbData(success: @escaping completion, failure: @escaping failure) {
        MKDeviceInterface.readDoNotDisturb { (data) in
            print("*** Do not Disturb Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to read Disturb")
        }
    }
    
    ///
    // MARK:- READ USER DATA -
    ///
    
    static func readUserData(success: @escaping completion, failure: @escaping failure) {
        MKUserDataInterface.readUserData { (data) in
            print("*** readUserData Data *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readUserData")
        }
    }
    
    ///
    // MARK:- READ USER SPORTS DATA -
    ///
    
    static func readUserSportsData(success: @escaping completion, failure: @escaping failure) {
        
        let timeModel = MKReadDataTimeModel()
        timeModel.year = 2020
        timeModel.month = 1
        timeModel.day = 1
        timeModel.hour = 1
        timeModel.minutes = 1
        
        MKUserDataInterface.readSportData(withTimeStamp: timeModel) { (data) in
            print("*** readSportData *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readSportData")
        }
    }
    
    ///
    // MARK:- READ TARGET MOVING DATA -
    ///
    
    static func readTargetMovingData(success: @escaping completion, failure: @escaping failure) {
        MKUserDataInterface.readMovingTarget { (data) in
            print("*** readMovingTarget *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readMovingTarget")
        }

    }
    
    ///
    // MARK:- READ USER SPORTS HEART RATE DATA -
    ///
    
    static func readUserSportsHeartRateData(success: @escaping completion, failure: @escaping failure) {
        
        let timeModel = MKReadDataTimeModel()
        timeModel.year = 2000
        timeModel.month = 1
        timeModel.day = 1
        timeModel.hour = 1
        timeModel.minutes = 1
        
        MKUserDataInterface.readSportHeartRateData(withTimeStamp: timeModel) { (data) in
            print("*** readSportHeartRateData *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readSportHeartRateData")
        }
    }
    
    ///
    // MARK:- READ STEPS Interval Data -
    ///
    
    static func readStepIntervalDataWithTimeStamp(success: @escaping completion, failure: @escaping failure) {
        
        let timeModel = MKReadDataTimeModel()
        timeModel.year = 2020
        timeModel.month = 1
        timeModel.day = 1
        timeModel.hour = 1
        timeModel.minutes = 1
        
        MKUserDataInterface.readStepIntervalData(withTimeStamp: timeModel) { (data) in
            print("*** readStepIntervalData *** \n\(data ?? "")")
            success(data)
        } failedBlock: { (err) in
            failure(err?.localizedDescription ?? "Unable to readStepIntervalData")
        }
    }
}
