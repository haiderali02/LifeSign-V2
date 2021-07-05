//
//  UserStats.swift
//  Core Flow
//
//  Created by Apple on 03/02/2021.
//

import Foundation
import FitpoloSDK_iOS


class UserStats: NSObject {
    
    typealias completion = (String) -> Void
    typealias failure = (String) -> Void
    
    private var stepsData: [String: Any] = [:]
    private var heartRateData: [String: Any] = [:]
    private var avgDailyHeartList: [[String: Any]] = [[:]]
    private var detailHeartList: [[String: Any]] = [[:]]
    private var sleepData: [String: Any] = [:]
    
    static let shared = UserStats()
    
    func uploadUserStats(){
        
        // UPLOAD USER STEP DATA
      
        MKReadInterface.readStepData { [self] (data) in
            self.stepsData.removeAll()
            if let resp = data as? [Any] {
                if let lastObject = resp.last as? [String: Any] {
                    stepsData = lastObject
                }
            }
            print("STEP DATA: \(data ?? "")")
            // ConnectionManager.submitUserStepsData(["user_steps_data": self.stepsData])
        } failure: { (error) in
           
        }
        
        // UPLOAD USER HEART RATE DATA
       
        MKReadInterface.readHeartData { (data) in
            if let heartData = data as? [String: Any] {
                if let avgDailyList = heartData["averageDailyList"] as? [Any] {
                    self.avgDailyHeartList.removeAll()
                    for obj in avgDailyList {
                        if let ob = obj as? [String: Any] {
                            self.avgDailyHeartList.append(ob)
                        }
                    }
                }
                if let detailList = heartData["detailList"] as? [Any] {
                    self.detailHeartList.removeAll()
                    let heartArray = detailList.suffix(7)
                    for obj in heartArray {
                        if let item = obj as? [String: Any] {
                            self.detailHeartList.append(item)
                        }
                    }
                }
                
                print("HEART DATA \(data ?? "")")
                
                // ConnectionManager.submitUserHeartRate(["detailList": self.detailHeartList])
            }
           
        } failure: { (err) in
            
        }
        
        // USER USER SLEEP DATA
        MKReadInterface.readSleepData { (data) in
            if let sleepData = data as? [Any] {
                self.sleepData.removeAll()
                if let lastObject = sleepData.last as? [String: Any] {
                    self.sleepData = lastObject
                }
            }
           /* self.sleepData = [
                "awake" : 0,         //Wake up time , in minute.
                 "deepSleep" : 155,   //Deep sleep time, in minute.
                 "endDate" : "2019-06-07",   //Sleep end date.
                 "endTime" : "07:50",        //Sleep end time.
                 "lightSleep" : 360,  //Light sleep time, in minute.
                 "startDate" : "2019-06-06",  //Sleep start date.
                 "startTime" : "23:15",       //Sleep start time.
                "detailList" : [01, 01, 01]
            ] */
            
            print("SLEEP DATA: \(data ?? "")")
            
           // ConnectionManager.submitSleepData(["user_sleep_data": self.sleepData])
        } failure: { (err) in
        }
    }
    
}
