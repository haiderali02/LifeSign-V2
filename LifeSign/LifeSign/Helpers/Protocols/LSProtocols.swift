//
//  LSProtocols.swift
//  LifeSign
//
//  Created by Haider Ali on 07/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit

protocol SOSHomeCellProtoCol: AnyObject {
    func didTapSeeAll()
    func didTapTotalFriends()
    func didTapAddNewSOSFriends()
    func didTapViewRequest()
}


protocol DailySignCellProtoCol: AnyObject {
    func displayUserDailySignInfo(userFriend: Items?)
}
