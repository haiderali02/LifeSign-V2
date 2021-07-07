//
//  Helper.swift
//  LifeSign
//
//  Created by Haider Ali on 31/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import Kingfisher
import SnapKit

class Helper: NSObject {
    
    static func isSOSScreenVisible() -> Bool {
        return UserDefaults.standard.bool(forKey: .sosScreenAppeared)
    }
    
    static func isMultiSOSScreenVisible() -> Bool {
        return UserDefaults.standard.bool(forKey: .sosMultiScreenAppeared)
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    static func saveLanguageLocale(lang: String, imageUrl: String) {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(imageUrl, forKey: "LangImageURL")
        defaults.setValue(lang, forKey: "AppLanguage")
    }
    
    static func getLangImageURL() -> String {
        let defaults = UserDefaults.standard
        guard let imgURL = defaults.value(forKey: "LangImageURL") as? String else {return "en"}
        return imgURL
    }
    
    static func getSelectedLanguage() -> String {
        let defaults = UserDefaults.standard
        guard let valeForLocale = defaults.value(forKey: "AppLanguage") as? String else {return "en"}
        return valeForLocale
    }
    
    static func removeFrineObjectFromLocal(friend_id: Int) {
        let defaults = UserDefaults.standard
        
        var savedGameFriends = defaults.value(forKey: "GameStats") as? [String: Any] ?? [:]
        
        savedGameFriends.removeValue(forKey: "game_stats_\(friend_id)")
        defaults.setValue(savedGameFriends, forKey: "GameStats")
    }
    
    static func getSavedGameFriends() -> [String: Any] {
        let defaults = UserDefaults.standard
        let savedGameFriends = defaults.value(forKey: "GameStats") as? [String: Any]
        
        print("VALUES: \(savedGameFriends ?? [:])")
        
        return savedGameFriends ?? [:]
    }
    
    
    static func getRandomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    
    
    static func sendNotification(toUserFcmTokken:String, text:String, title: String) {
        
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
        
        let postParams: [String : AnyObject] = ["apns": [
            "payload": [
                "aps": [
                    "mutable-content": 1
                ]
            ],
            "fcm_options": [
                "image": "http://uztrip.twaintec.com/images/users/Khawar-5ecf6c05f1c82.jpg"
            ]
        ] as AnyObject, "to":"\(toUserFcmTokken)" as AnyObject,"data": ["type":"Game","name":"","user_id":""] as AnyObject, "notification": ["body": "\(text)", "title": "\(title)" ,"sound" : "default"] as AnyObject]
        //, "badge" : totalBadgeCount
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAqN2ctZI:APA91bGY-II1wfn1bDe89GUFFYlqT7BrrwaOWEt8roOPnx_VE3mQtN3-_e1ZLuLfjRSLJCJICIq7oDPfMttPvV7Oh0C-qWWjIfRwO2ClEBnTKvwK4aXyaB1Ukqe7ogJXmxvfptDzU_hc", forHTTPHeaderField: "Authorization")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print("My paramaters: \(postParams)")
        }
        catch{
            print("Caught an error: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let realResponse = response as? HTTPURLResponse{
                if realResponse.statusCode != 200{
                    print("Not a 200 response")
                }
            }
            
            if error == nil {
                if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?{
                    print("POST: \(postString)")
                }
            }
        }
        
        task.resume()
    }
    
}
