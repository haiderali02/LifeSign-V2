//
//  OKSignHomeCell.swift
//  LifeSign
//
//  Created by Haider Ali on 13/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import PopBounceButton
import EmptyDataSet_Swift


class OKSignHomeCell: UITableViewCell {
    
    @IBOutlet weak var okSignButton: UIButton! {
        didSet {
            okSignButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var okSignSeeAllCheckFriendButton: UIButton! {
        didSet {
            okSignSeeAllCheckFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var okSignAddCheckFriendButton: UIButton! {
        didSet {
            okSignAddCheckFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var totalOKSignCheckFriendButton: UIButton! {
        didSet {
            totalOKSignCheckFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var viewCheckFriendRequestButton: UIButton! {
        didSet {
            viewCheckFriendRequestButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    
    @IBOutlet weak var checkFriendCollectionView: UICollectionView! {
        didSet {
            checkFriendCollectionView.delegate = self
            checkFriendCollectionView.dataSource = self
            
            checkFriendCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    
    @IBOutlet weak var okSignTellFriendButton: UIButton! {
        didSet {
            okSignTellFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var okSignSeeAllTellFriendButton: UIButton! {
        didSet {
            okSignSeeAllTellFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var okSignAddTellFriendButton: UIButton! {
        didSet {
            okSignAddTellFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var totalOKSignTellFriendButton: UIButton! {
        didSet {
            totalOKSignTellFriendButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var viewTellFriendRequestButton: UIButton! {
        didSet {
            viewTellFriendRequestButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    
    @IBOutlet weak var TellFriendCollectionView: UICollectionView! {
        didSet {
            TellFriendCollectionView.delegate = self
            TellFriendCollectionView.dataSource = self
            
            TellFriendCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    var userCheckFriends: [Items] = [Items]()
    var userTellFriends: [Items] = [Items]()
    
    var selectedIndexCheckFriends: [IndexPath] = [IndexPath]()
    var selectedIndexTellFriends: [IndexPath] = [IndexPath]()
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setText()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .refreshData, object: nil)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_ ) in
            self.checkFriendCollectionView.reloadItems(at: self.selectedIndexCheckFriends)
            self.TellFriendCollectionView.reloadItems(at: self.selectedIndexTellFriends)
        }
        
    }
    
    @objc func setText() {
        okSignButton.setTitle(AppStrings.getOkSignTitle(), for: .normal)
        okSignTellFriendButton.setTitle(AppStrings.getOkSignTitle(), for: .normal)
        okSignSeeAllTellFriendButton.setTitle(AppStrings.getSeeAllString(), for: .normal)
        okSignSeeAllCheckFriendButton.setTitle(AppStrings.getSeeAllString(), for: .normal)
        okSignAddTellFriendButton.setTitle(AppStrings.getAddNewString(), for: .normal)
        okSignAddCheckFriendButton.setTitle(AppStrings.getAddNewString(), for: .normal)
        
        if UserCounters.shared.okTellFriend > 0 {
            viewTellFriendRequestButton.setTitle(AppStrings.getViewRequestString() + " (\(UserCounters.shared.okTellFriend))", for: .normal)
        } else {
            viewTellFriendRequestButton.setTitle(AppStrings.getViewRequestString(), for: .normal)
        }
        viewCheckFriendRequestButton.setTitle(AppStrings.getViewRequestString(), for: .normal)
        totalOKSignTellFriendButton.setTitle(AppStrings.getTellFriendsString(), for: .normal)
        totalOKSignCheckFriendButton.setTitle(AppStrings.getCheckFriendString(), for: .normal)
        
        self.checkFriendCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        self.TellFriendCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        
        self.checkFriendCollectionView.reloadData()
        self.TellFriendCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension OKSignHomeCell: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == checkFriendCollectionView ? userCheckFriends.count : userTellFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        cell?.emptyCell()
        cell?.userTimeZoneLabel.isHidden = true
        let userData = collectionView == checkFriendCollectionView ? userCheckFriends[indexPath.row] : userTellFriends[indexPath.row]
        cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: collectionView == self.checkFriendCollectionView ? .checkFriend : .tellFriend)
        
        cell?.trailingButton.tag = indexPath.row
        
        if collectionView == checkFriendCollectionView {
            cell?.trailingButton.addTarget(self, action: #selector(didTapSendReminder(_:)), for: .touchUpInside)
        } else {
            cell?.trailingButton.addTarget(self, action: #selector(didTapSendOKSign(_:)), for: .touchUpInside)
            cell?.trailingButton.backgroundColor = UIColor.white
        }
        
        if collectionView == checkFriendCollectionView {
            
            // Reminder Tab
            
            if userData.remind_time != "" {
                // Means Show Timer
                
                var nextTime = Date()
                nextTime = userData.remind_time.getDateObjectFromString()
                let nowTime = Date()
                
                if let oneHourAhead = Calendar.current.date(byAdding: .minute, value: Constants.timerInterval, to: nextTime) {
                    if nowTime < oneHourAhead {
                        cell?.userTimeZoneLabel.isHidden = false
                        cell?.buttonContainerView.isHidden = true
                        let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                        let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: oneHourAhead)
                        let onHrTimer = self.componentsFormatter.string(from: components)
                        cell?.userTimeZoneLabel.font = Constants.bigButtonFont
                        cell?.userTimeZoneLabel.text = onHrTimer
                        if !self.selectedIndexCheckFriends.contains(indexPath) {
                            self.selectedIndexCheckFriends.append(indexPath)
                        }
                    }
                }
            }
            
        } else {
            
            // I am Ok Tab
            
            if userData.agreement_next_time != "" {
                // Means Show Timer
                var nextTime = Date()
                nextTime = userData.agreement_next_time.getDateObjectFromString()
                let nowTime = Date()
                if let oneHourAhead = Calendar.current.date(byAdding: .minute, value: Constants.timerInterval, to: nextTime) {
                    if nowTime < oneHourAhead {
                        cell?.userTimeZoneLabel.isHidden = false
                        cell?.buttonContainerView.isHidden = true
                        let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                        let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: oneHourAhead)
                        let onHrTimer = self.componentsFormatter.string(from: components)
                        cell?.userTimeZoneLabel.font = Constants.bigButtonFont
                        cell?.userTimeZoneLabel.text = onHrTimer
                        if !self.selectedIndexTellFriends.contains(indexPath) {
                            self.selectedIndexTellFriends.append(indexPath)
                        }
                    }
                }
            }
        }
        cell?.redDot.isHidden = true
        
        // Display GotIt Button
        
        if userData.is_read == 1 && userData.initiator == 1 {
            cell?.redDot.isHidden = false
            cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: .gotIt)
            
        }
        
        // Display State When Reminder is received
        
        if userData.initiator == 0 && userData.read_reminder == 1 {
            // Display Reminder Received
            cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: .reminderReceived)
            
            
        }
        cell?.buttonTopSpace.constant = 0
        cell?.adjustImageHeigt(heigth: 40, width: 40)
        return cell ?? FriendsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            return CGSize(width: (Constants.screenWidth / 4) + 20, height: 180)
        }
        else
        {
            return CGSize(width: (Constants.screenWidth / 3) + 20, height: 180)
        }
    }
    
    @objc func didTapSendReminder(_ sender: DesignableButton) {
        print("Send Reminder: \(sender.tag)")
        sender.showLoading()
        sender.showAnimation {
            let userData = self.userCheckFriends[sender.tag]
            
            if userData.is_read == 1 && userData.initiator == 1 {
                // Perform GotIt Action
                
                LifeSignManager.markAgreementSeen(agreementID: "\(userData.agreement_id)") { (status, errors) in
                    sender.hideLoading()
                    if errors == nil {
                        // Refresh Home
                        NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                    } else {
                        
                    }
                }
                return
            }
            
            LifeSignManager.sendReminderToUser(agreementID: "\(userData.agreement_id)") { (status, errors) in
                sender.hideLoading()
                if errors == nil {
                    // Refresh Home
                    NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                } else {
                    
                }
            }
        }
    }
    
    @objc func didTapSendOKSign(_ sender: DesignableButton) {
        print("Send OKSign: \(sender.tag)")
        sender.showLoading()
        sender.showAnimation {
            let userData = self.userTellFriends[sender.tag]
            LifeSignManager.sendIAMOKToUSER(agreementID: "\(userData.agreement_id)") { (status, errors) in
                if errors == nil {
                    // Refresh Home
                    sender.hideLoading()
                    NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                } else {
                    
                }
            }
        }
    }
}
