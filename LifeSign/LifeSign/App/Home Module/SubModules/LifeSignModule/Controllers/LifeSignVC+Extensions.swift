//
//  LifeSignVC+Extensions.swift
//  LifeSign
//
//  Created by Haider Ali on 07/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Starscream
// import SocketIO
import SwiftySound

///
// MARK:- SOS FUNCTIONS EXTENSION
///
extension LifeSignVC {
    
    func getUserSOSFriends(searcString: String?, pageNumer: Int = 0, userLimit: Int? = 20) {
        
        SOSManager.getSOSFriendsList(searchString: searcString, limit: userLimit, PageNumber: pageNumer) { (friendsData, errors, links) in
            self.removeSpinner()
            self.disPatchWaiting.leave()
            self.refreshControl.endRefreshing()
            if errors == nil {
                guard let userFriends = friendsData?.items else {
                    
                    if !(pageNumer > 1) {
                        self.userSOSFriendsData.removeAll()
                    }
                    self.homeTableView.reloadData()
                    return
                }
                if !(pageNumer > 1) {
                    self.userSOSFriendsData.removeAll()
                }
                
                for users in userFriends {
                    if users.sos_request == .accepted {
                        self.userSOSFriendsData.append(users)
                    }
                }
                
                self.homeTableView.reloadData()
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    // SOS CELL
    
    func configureSOSCell(tableView: UITableView, forIndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.sosHomeCell, for: forIndexPath)
        cell?.sosButton.tag = forIndexPath.row
        cell?.seeAllButton.tag = forIndexPath.row
        cell?.sosMainButton.tag = forIndexPath.row
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1.5
        cell?.sosMainButton.addGestureRecognizer(longPress)
        cell?.totalFriendsButton.tag = forIndexPath.row
        cell?.sosAddNewButton.tag = forIndexPath.row
        cell?.sosFriendsCollectionView.tag = forIndexPath.row
        cell?.viewRequestButton.tag = forIndexPath.row
        
        cell?.sosMainButton.setTitle(self.enableSOSButton ? AppStrings.getPushForThreeSecString() : AppStrings.sosSents(), for: .normal)
        cell?.sosMainButton.isEnabled = self.enableSOSButton
        
        cell?.totalFriendsButton.setTitle("\(self.userSOSFriendsData.count) \(AppStrings.getFriendsString())", for: .normal)
        
        cell?.userSOSFriends = self.userSOSFriendsData
        cell?.sosFriendsCollectionView.reloadData()
        cell?.seeAllButton.addTarget(self, action: #selector(didTapSeeAllButton(_:)), for: .touchUpInside)
        cell?.sosMainButton.addTarget(self, action: #selector(didTapSendSOSButton(_:)), for: .touchUpInside)
        cell?.sosAddNewButton.addTarget(self, action: #selector(didTapAddNewButton(_:)), for: .touchUpInside)
        cell?.totalFriendsButton.addTarget(self, action: #selector(didTapUserSOSFriends(_:)), for: .touchUpInside)
        cell?.viewRequestButton.addTarget(self, action: #selector(didTapViewRequestSOSButton(_:)), for: .touchUpInside)
        
        return cell ?? SOSHomeCell()
    }
    
    func startTimerAndResetButton() {
        Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { (time) in
            self.enableSOSButton = true
            self.timer?.invalidate()
            self.homeTableView.reloadData()
        }
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            SOSManager.sendSOS { (status, displayPopup, message, errors) in
                if errors == nil {
                    if displayPopup != nil {
                        // Show SMS Runout Alert
                        self.showBuySMSAlert(message ?? "")
                    }
                    self.enableSOSButton = false
                    Sound.play(file: .sosSent)
                    self.startTimerAndResetButton()
                    self.homeTableView.reloadData()
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
    }
    
    func showBuySMSAlert(_ message: String) {
        let alertController = UIAlertController(title: AppStrings.getAlertString(), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Simply Dismiss
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getBuySMSString(), style: .default, handler: { (_ ) in
            // Redirect To Shop To Buy SMS
            NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex": 2])
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showUserFriends() {
        if let controller = R.storyboard.friends.friendsVC() {
            controller.modalPresentationStyle = .overCurrentContext
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // MARK:- SOS CELL ACTIONS -
    @objc func didTapSeeAllButton(_ sender: UIButton) {
        sender.showAnimation {
            self.sosCellDelegates?.didTapSeeAll()
        }
    }
    @objc func didTapSendSOSButton(_ sender: UIButton) {
        // SEND SOS TO ALL FRIEND
        // Hanlded view long Tap Gesture
        sender.showAnimation {
            guard let userSOSFriends = UserManager.shared.userFriends?.sos_friends else {return}
            if !(userSOSFriends > 0) {
                let alertController = UIAlertController(title: AppStrings.getAlertString(), message: AppStrings.getNoFriendInSOS(), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
                    // Simply Dismiss
                }))
                alertController.addAction(UIAlertAction(title: AppStrings.getGotoFriends(), style: .default, handler: { (_ ) in
                    NotificationCenter.default.post(name: .redirectToFriends, object: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    @objc func didTapAddNewButton(_ sender: UIButton) {
        sender.showAnimation {
            self.showUserFriends()
        }
    }
    @objc func didTapUserSOSFriends(_ sender: UIButton) {
        sender.showAnimation {
            self.sosCellDelegates?.didTapTotalFriends()
        }
    }
    @objc func didTapViewRequestSOSButton(_ sender: UIButton) {
        sender.showAnimation {
            self.sosCellDelegates?.didTapViewRequest()
        }
    }
}



///
// MARK:- OKSIGN FUNCTIONS EXTENSION
///

extension LifeSignVC : HealthCellDelegates{
    
    func getUserOKSignFriends(searchString: String?) {
        LifeSignManager.getOKSignFriendsList(searchString: searchString, limit: 10, PageNumber: nil) { (friendsData, errors, links) in
            self.disPatchWaiting.leave()
            if errors == nil {
                self.userCheckFriends.removeAll()
                self.userTellFriends.removeAll()
                self.refreshControl.endRefreshing()
                
                if let userOkFriends = friendsData?.items {
                    
                    for user in userOkFriends {
                        if user.initiator == 1 {
                            if user.agreement_request == .accepted {
                                self.userCheckFriends.append(user)
                            }
                            
                        } else {
                            if user.agreement_request == .accepted {
                                self.userTellFriends.append(user)
                            }
                        }
                    }
                    NotificationCenter.default.post(name: .refreshData, object: nil)
                    self.homeTableView.reloadData()
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    
    // OK SIGN CELL
    
    func configureOKCell(tableView: UITableView, forIndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.okSignHomeCell, for: forIndexPath)
        
        
        cell?.okSignButton.tag = forIndexPath.row
        cell?.okSignTellFriendButton.tag = forIndexPath.row
        cell?.okSignSeeAllTellFriendButton.tag = forIndexPath.row
        cell?.okSignSeeAllCheckFriendButton.tag = forIndexPath.row
        cell?.okSignAddTellFriendButton.tag = forIndexPath.row
        cell?.okSignAddCheckFriendButton.tag = forIndexPath.row
        cell?.viewTellFriendRequestButton.tag = forIndexPath.row
        cell?.viewCheckFriendRequestButton.tag = forIndexPath.row
        cell?.totalOKSignTellFriendButton.tag = forIndexPath.row
        cell?.totalOKSignCheckFriendButton.tag = forIndexPath.row
        cell?.checkFriendCollectionView.tag = forIndexPath.row
        cell?.TellFriendCollectionView.tag = forIndexPath.row
       
        
        
        cell?.okSignSeeAllCheckFriendButton.addTarget(self, action: #selector(didTapSeeAllCheckFriends(_:)), for: .touchUpInside)
        cell?.okSignSeeAllTellFriendButton.addTarget(self, action: #selector(didTapSeeAllTellFriends(_:)), for: .touchUpInside)
        
        cell?.okSignAddTellFriendButton.addTarget(self, action: #selector(didTapAddNewTellFriends(_:)), for: .touchUpInside)
        cell?.okSignAddCheckFriendButton.addTarget(self, action: #selector(didTapAddNewCheckFriends(_:)), for: .touchUpInside)
        
        cell?.viewCheckFriendRequestButton.addTarget(self, action: #selector(didTapViewAllCheckFriends(_:)), for: .touchUpInside)
        cell?.viewTellFriendRequestButton.addTarget(self, action: #selector(didTapViewAllTellFriends(_:)), for: .touchUpInside)
        
        cell?.userCheckFriends = self.userCheckFriends
        cell?.userTellFriends = self.userTellFriends
        
        cell?.checkFriendCollectionView.reloadData()
        cell?.TellFriendCollectionView.reloadData()
        return cell ?? OKSignHomeCell()
    }
    
    // Healt CELL
    
    func configureHealthCell(tableView: UITableView, forIndexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.healthHomeCell, for: forIndexPath)
        
        cell?.addNewFriendLabel.addTarget(self, action: #selector(self.didTapAddNewButton(_:)), for: .touchUpInside)
        cell?.viewRequestLabel.addTarget(self, action: #selector(self.didTapViewHealthRequest(_:)), for: .touchUpInside)
        cell?.btnSeeAll.addTarget(self, action: #selector(self.didTapSeeAllHealthFriends(_:)), for: .touchUpInside)
        
        cell?.delegates = self
        
        return cell ?? OKSignHomeCell()
    }
    
    // MARK:- HEALTH ACTIONs -
    
    @objc func didTapViewHealthRequest(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
    @objc func didTapSeeAllHealthFriends(_ sender: UIButton) {
        sender.showAnimation {
            guard let seeHealthVC = R.storyboard.healthBoard.healthVC() else{
                return
            }
            
            self.navigationController?.pushViewController(seeHealthVC, animated: true)
        }
    }
    // HEALTH CELL DELEGATES
    func didTapFriendCell(at index: Int) {
        print("Selected At: \(index)")
    }
    
    // MARK:- OKSIGN CELL ACTIONS -
    
    @objc func didTapSeeAllCheckFriends(_ sender: UIButton) {
        sender.showAnimation {
            if let controller = R.storyboard.lifeSign.okSignVC() {
                controller.mode = .checkFriend
                self.push(controller: controller, animated: true)
            }
        }
        
    }
    @objc func didTapSeeAllTellFriends(_ sender: UIButton) {
        sender.showAnimation {
            if let controller = R.storyboard.lifeSign.okSignVC() {
                controller.mode = .tellFriend
                self.push(controller: controller, animated: true)
            }
        }
    }
    
    @objc func didTapAddNewCheckFriends(_ sender: UIButton) {
        sender.showAnimation {
            self.showUserFriends()
        }
    }
    @objc func didTapAddNewTellFriends(_ sender: UIButton) {
        sender.showAnimation {
            self.showUserFriends()
        }
    }
    
    @objc func didTapViewAllCheckFriends(_ sender: UIButton) {
        sender.showAnimation {
            if let controller = R.storyboard.lifeSign.okSignVC() {
                controller.mode = .checkFriend
                self.push(controller: controller, animated: true)
            }
        }
        
    }
    @objc func didTapViewAllTellFriends(_ sender: UIButton) {
        sender.showAnimation {
            if let controller = R.storyboard.lifeSign.okSignVC() {
                controller.mode = .tellFriend
                self.push(controller: controller, animated: true)
            }
        }
    }
}


///
// MARK:- DAILY SIGN FUNCTIONS
///

extension LifeSignVC: DailySignCellProtoCol {
    
    func configureDailySign(tableView: UITableView, forIndexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dailySignHomeCell, for: forIndexPath)
        cell?.dailySignBtn.tag = forIndexPath.row
        cell?.seeAllBtn.tag = forIndexPath.row
        cell?.addNewDailySignFriendBtn.tag = forIndexPath.row
        cell?.dailySignCollectionView.tag = forIndexPath.row
        cell?.viewDailySignRequest.tag = forIndexPath.row
        cell?.totalFriendsBtn.tag = forIndexPath.row
        cell?.delegate = self
        cell?.timer?.invalidate()
        cell?.timer = nil
        cell?.seeAllBtn.addTarget(self, action: #selector(didTapSeeAllDailSign(_:)), for: .touchUpInside)
        cell?.addNewDailySignFriendBtn.addTarget(self, action: #selector(didTapAddNewDailySign(_:)), for: .touchUpInside)
        cell?.viewDailySignRequest.addTarget(self, action: #selector(didTapViewRequestDailySign(_:)), for: .touchUpInside)
        
        cell?.userDailySignFriends = self.userDailySignFriends
        cell?.dailySignCollectionView.reloadData()
        return cell ?? DailySignHomeCell()
    }
    
    
    // MARK:- DailySign ACTIONS -
    
    @objc func didTapSeeAllDailSign(_ sender: UIButton) {
        sender.showAnimation {
            if let controller = R.storyboard.lifeSign.dailySignVC() {
                controller.mode = .allFriends
                self.push(controller: controller, animated: true)
            }
        }
    }
    @objc func didTapViewRequestDailySign(_ sender: UIButton) {
        sender.showAnimation {
            if let controller = R.storyboard.lifeSign.dailySignVC() {
                controller.mode = .friendRequest
                self.push(controller: controller, animated: true)
            }
        }
    }
    @objc func didTapAddNewDailySign(_ sender: UIButton) {
        sender.showAnimation {
            self.showUserFriends()
        }
    }
    
    
    // MARK:- DAILYSIGN CELL DELEGATES -
    
    func displayUserDailySignInfo(userFriend: Items?) {
        if let controller = R.storyboard.lifeSign.editDailySignVC() {
            controller.definesPresentationContext = true
            controller.userFreind = userFriend
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
}



///
// MARK:- DailySign -
///

extension LifeSignVC {
    
    
    func getUserDailySignFriends(searcString: String?, pageNumer: Int = 0, userLimit: Int? = 20) {
        
        LifeSignManager.getUserDailySignFriends(searchString: searcString, limit: userLimit, PageNumber: pageNumer) { (friendsData, allowedContacts ,errors , links) in
            self.removeSpinner()
            self.disPatchWaiting.leave()
            self.refreshControl.endRefreshing()
            if errors == nil {
                guard let userFriends = friendsData?.items else {
                    
                    if !(pageNumer > 1) {
                        self.userDailySignFriends.removeAll()
                    }
                    self.homeTableView.reloadData()
                    return
                }
                if !(pageNumer > 1) {
                    self.userDailySignFriends.removeAll()
                }
                
                for users in userFriends {
                    self.userDailySignFriends.append(users)
                }
                
                self.homeTableView.reloadData()
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
}
