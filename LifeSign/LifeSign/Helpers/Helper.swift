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
    
}
