//
//  File.swift
//  LifeSign
//
//  Created by Haider Ali on 30/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import UIKit
import SwiftyContacts
import MessageUI

extension FriendsVC {
    
    
    func handleFriendsButtonTapped() {
        if myFriendsBtn.isSelected {
            // Set Button Stats
            self.setStatsForButton(button: myFriendsBtn)
            // Get My Friends
            self.getUserFriends(searcString: nil, pageNumer: self.currentPageNumber, userLimit: nil)
        }
    }
    
    func handlePeopleButtonTapped() {
        
        // Set Button Stats
        self.setStatsForButton(button: self.peopleBtn)
        // Get Peoples In Sub Categories : i.e Local, National, International
        /// Initially get Local friends
        self.didTapLocalPerson(self.localPeopleBtn)
    }
    
    func handleInviteFriendsTapped() {
        // Set Buttons Stats
        self.setStatsForButton(button: self.inviteFriendsBtn)
    }
    
    func setStatsForButton(button: DesignableButton) {
        
        if button == myFriendsBtn {
            
            self.friendsTableView.tableHeaderView = nil
            
            myFriendsBtn.backgroundColor = R.color.appYellowColor()
            myFriendsBtn.setTitleColor(R.color.appBoxesColor(), for: .normal)
            
            peopleBtn.backgroundColor = R.color.appBoxesColor()
            peopleBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            inviteFriendsBtn.backgroundColor = R.color.appBoxesColor()
            inviteFriendsBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            self.userFriendsData.removeAll()
            self.friendsTableView.reloadData()
            
            
        } else if button == peopleBtn {
            
            self.friendsTableView.tableHeaderView = self.tableHeaderView
            
            peopleBtn.backgroundColor = R.color.appYellowColor()
            peopleBtn.setTitleColor(R.color.appBoxesColor(), for: .normal)
            
            myFriendsBtn.backgroundColor = R.color.appBoxesColor()
            myFriendsBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            inviteFriendsBtn.backgroundColor = R.color.appBoxesColor()
            inviteFriendsBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            self.peopleData.removeAll()
            self.friendsTableView.reloadData()
            
        } else if button == inviteFriendsBtn {
            
            self.friendsTableView.tableHeaderView = nil
            
            inviteFriendsBtn.backgroundColor = R.color.appYellowColor()
            inviteFriendsBtn.setTitleColor(R.color.appBoxesColor(), for: .normal)
            
            myFriendsBtn.backgroundColor = R.color.appBoxesColor()
            myFriendsBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            peopleBtn.backgroundColor = R.color.appBoxesColor()
            peopleBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            
            self.userContacts.removeAll()
            self.friendsTableView.reloadData()
            self.isBeingFetched = true
            requestAccess { (isGranted) in
                DispatchQueue.main.async {
                    self.isBeingFetched = false
                }
                if isGranted {
                    self.getContacts()
                } else {
                    print("Permission Not Granted")
                    
                    DispatchQueue.main.async {
                        self.showSettingsAlert { display in
                        }
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
        
    }
    
    
    func getUserFriends(searcString: String?, pageNumer: Int = 0, userLimit: Int? = 20) {
        self.isBeingFetched = true
        FriendManager.getUserFriends(searchString: searcString, limit: userLimit, PageNumber: pageNumer) { (friendsData, errors, links) in
            self.userFriendsData.removeAll()
            self.isBeingFetched = false
            self.friendsTableView.reloadData()
            if errors == nil {
                guard let userFriends = friendsData?.items else {
                    self.refreshControl.endRefreshing()
                    if !(pageNumer > 1) {
                        self.userFriendsData.removeAll()
                    }
                    self.friendsTableView.reloadData()
                    return
                }
                if !(pageNumer > 1) {
                    self.userFriendsData.removeAll()
                }
                self.paginationLinks = links
                
                let friends = userFriends.sorted(by: { (friend_1, friend_2) -> Bool in
                    friend_1.friend_status == .pending
                })
                
                self.userFriendsData.append(contentsOf: friends)
                
                if self.mode == .Inbox || self.mode == .addNew || self.mode == .game {
                    self.userFriendsData.removeAll { friend in
                        return friend.friend_status == .pending
                    }
                }
                
                self.refreshControl.endRefreshing()
                self.friendsTableView.reloadData()
            } else {
                self.refreshControl.endRefreshing()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func getLifeSignUsers(type: PeopleTypes, searchString: String?, pageNumer: Int = 1) {
        self.isBeingFetched = true
        FriendManager.getLifeSignUsers(type: type, searchString: searchString, limit: 20, PageNumber: pageNumer) { (friendsData, errors, links) in
            self.peopleData.removeAll()
            self.isBeingFetched = false
            self.friendsTableView.reloadData()
            if errors == nil {
                guard let peoples = friendsData?.items else {
                    if !(pageNumer > 1) {
                        self.peopleData.removeAll()
                        self.friendsTableView.reloadData()
                    }
                    self.refreshControl.endRefreshing()
                    return
                }
                self.paginationLinks = links
                if !(pageNumer > 1) {
                    self.peopleData.removeAll()
                }
                
                self.peopleData.append(contentsOf: peoples)
                self.friendsTableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                self.refreshControl.endRefreshing()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    
    func getContacts() {
        // self.showSpinner(onView: self.view)
        fetchContacts(order: .givenName) { (results) in
            self.removeSpinner()
            switch results {
            case .success(let contacts):
                self.removeSpinner()
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                self.userContacts = contacts.filter({ (contact) -> Bool in
                    return contact.phoneNumbers.count > 0
                })
            case .failure(let error):
                self.removeSpinner()
                self.refreshControl.endRefreshing()
                print("Errors: \(error.localizedDescription)")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.removeSpinner()
            }
        }
    }
}


extension FriendsVC: MFMessageComposeViewControllerDelegate {
    
    func handleTrailingButtonTapped(view: UserCellType, userIndex: Int) {
        
        switch view {
        case .myFriend:
            print("Hello Friend: \(userIndex)")
            
            let userFriend = self.userFriendsData[userIndex]
            // Open Friend Detail Page
            if userFriend.request_status == .accepted {
                if let controller = R.storyboard.friends.friendDetailVC() {
                    controller.userFreind = userFriend
                    controller.openChatWitFriend = { (friend) in
                        guard let userFriend = friend else {return}
                        self.openChatWith(friend: userFriend)
                    }
                    controller.navigateToShop = { (friend) in
                        // self.shouldNavigateToShope?(0, nil)
                        NotificationCenter.default.post(name: .redirectToShop, object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.present(controller, animated: true, completion: nil)
                }
            } else if userFriend.request_status == .pending {
                // Accept Request
                
                self.showSpinner(onView: self.view)
                FriendManager.acceptRejectFriendRequest(requestStatus: .accepted, requestID: "\(userFriend.friend_request_id)") { (status, errors) in
                    self.removeSpinner()
                    if errors == nil {
                        self.didTapMyFriends(self.myFriendsBtn)
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.removeSpinner()
                    }
                }
                
            } else if userFriend.request_status == .waiting {
                // Show Cancel Request Alert
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: AppStrings.getCancelRequestString(), style: .destructive, handler: { (_ ) in
                    // Hit Cancel Request API
                    self.showSpinner(onView: self.view)
                    FriendManager.acceptRejectFriendRequest(requestStatus: .cancel, requestID: "\(userFriend.friend_request_id)") {
                        (status, errors) in
                        self.removeSpinner()
                        if errors == nil {
                            self.removeSpinner()
                            self.userFriendsData.removeAll { obj in
                                return obj.friend_request_id == userFriend.friend_request_id
                            }
                            self.friendsTableView.reloadData()
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                    }
                    
                }))
                alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
                    // Simply dismiss
                }))
                
                if let popoverController = alertController.popoverPresentationController {
                    popoverController.sourceView = self.friendsTableView
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        case .people:
            print("Hello People: \(userIndex)")
            
            let friend = peopleData[userIndex]
            self.showSpinner(onView: self.view)
            FriendManager.sendFriendReuqest(toUserWitID: "\(friend.friend_id)") { (status, errors) in
                self.removeSpinner()
                if errors == nil {
                    
                    AlertController.showAlert(witTitle: friend.first_name + " " + friend.last_name, withMessage: AppStrings.requestSentSuccess(), style: .success, controller: self)
                   
                    self.peopleData.removeAll { peopleObj in
                        return peopleObj.friend_id == friend.friend_id
                    }
                    
                    self.friendsTableView.reloadData()
                    
                    self.removeSpinner()
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.removeSpinner()
                }
            }
        case .inviteFriends:
            print(("Hello PhoneBook: \(userIndex)"))
            
            if self.searchBarField.text != "" {
                let contact =  self.filterPhoneContacts[userIndex]
                let contactName = CNContactFormatter.string(from: contact, style: .fullName)
                var contactNumber = ""
                print("Name: \(String(describing: contactName))")
                if contact.phoneNumbers.count > 0{
                    contactNumber = ((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                }
                self.displayMessageInterface(withNumber: contactNumber)
            } else {
                let contact = self.userContacts[userIndex]
                let contactName = CNContactFormatter.string(from: contact, style: .fullName)
                var contactNumber = ""
                print("Name: \(String(describing: contactName))")
                if contact.phoneNumbers.count > 0{
                    contactNumber = ((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                }
                self.displayMessageInterface(withNumber: contactNumber)
            }
            
            
        default:
            return
        }
    }
    
    func displayMessageInterface(withNumber: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [withNumber]
        composeVC.body = AppStrings.getShareLifeSign()
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print("LifeSign-Shared!")
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    func handleSearch(searchString: String) {
        switch friendsTypeView {
        case .myFriend:
            if searchString == "" {
                self.didTapMyFriends(self.myFriendsBtn)
            } else {
                self.getUserFriends(searcString: searchString)
            }
        case .people:
            if self.localPeopleBtn.isSelected {
                if searchString == "" {
                    self.didTapLocalPerson(self.localPeopleBtn)
                } else {
                    self.getLifeSignUsers(type: .local, searchString: searchString)
                }
            } else if self.internationalPeopleBtn.isSelected {
                if searchString == "" {
                    self.didTapInternationalPerson(self.internationalPeopleBtn)
                } else {
                    self.getLifeSignUsers(type: .international, searchString: searchString)
                }
            } else if self.nationalPeopleBtn.isSelected {
                if searchString == "" {
                    self.didTapNationalPeroson(self.nationalPeopleBtn)
                } else {
                    self.getLifeSignUsers(type: .national, searchString: searchString)
                }
            }
        case .inviteFriends:
            if searchString == "" {
                self.didTapInviteFriends(self.inviteFriendsBtn)
            } else {
                // Search in Phone Book Friends
                
                self.filterPhoneContacts = self.userContacts.filter({ (contact) -> Bool in
                    let contactName = CNContactFormatter.string(from: contact, style: .fullName)
                    var contactNumber = ""
                    if contact.phoneNumbers.count > 0{
                        contactNumber = ((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                    }
                    
                    return ((contactName?.containsIgnoringCase(find: searchString))! || contactNumber.containsIgnoringCase(find: searchString))
                    
                })
                
            }
        default:
            return
        }
    }
    
    func openChatWith(friend: Items) {
        if let controller = R.storyboard.chatBoard.chatVC() {
            let friend = InboxFriendModel(JSON: ["friend_id":friend.user_id, "is_online": false,"profile_image": friend.profile_image, "full_name": friend.first_name + " " + friend.last_name])
            controller.userFriend = friend
            self.push(controller: controller, animated: true)
        }
    }
    
    func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: AppStrings.appNeedsContactString(), preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: AppStrings.getOpenSetting(), style: .default) { action in
                    completionHandler(false)
                    UIApplication.shared.open(settings)
                })
        }
        alert.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
}
