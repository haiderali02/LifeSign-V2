//
//  MKConfigUserDataModel.swift
//  Core Flow
//
//  Created by Apple on 12/02/2021.
//

import Foundation

class MKConfigUserDataModel: NSObject, mk_configUserDataProtocol {
    
    var height: Int = 0
    var weight: Int = 0
    var gender: mk_fitpoloGender = .male
    var userAge: Int = 0
    
}
