//
//  OkSignVC.swift
//  LifeSign
//
//  Created by Haider Ali on 13/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class OkSignVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var okSignSegmentBar: UISegmentedControl! {
        didSet {
            let unSelectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appYellowColor]
            let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appBoxColor]
            okSignSegmentBar.setTitleTextAttributes(unSelectedAttribute, for: .normal)
            okSignSegmentBar.setTitleTextAttributes(selectedAttribute, for: .selected)
            okSignSegmentBar.selectedSegmentTintColor = UIColor.appYellowColor
        }
    }
    
    @IBOutlet weak var okSignCollectionView: UICollectionView! {
        didSet {
            okSignCollectionView.delegate = self
            okSignCollectionView.dataSource = self
            okSignCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    // MARK:- PROPERTIES -
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    var selectedIndex: [IndexPath] = [IndexPath]()
    
    var paginationLinks: Links?
    var refreshControl = UIRefreshControl()
    
    var userCheckFriends: [Items] = [Items]()
    var userTellFriends: [Items] = [Items]()
    
    var timer: Timer?
    
    var isBeingFetched = false {
        didSet {
            okSignCollectionView.reloadData()
        }
    }
    
    var mode: OKSignMode = {
        return .checkFriend
    }()
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        
        self.timer?.invalidate()
        self.timer = nil
        
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        okSignCollectionView.addSubview(refreshControl)
        self.okSignCollectionView!.alwaysBounceVertical = true
        self.okSignCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        getUserOKSignFriends(searchString: nil)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_ ) in
            self.okSignCollectionView.reloadItems(at: self.selectedIndex)
        }
        
        switch mode {
        case .checkFriend:
            self.okSignSegmentBar.selectedSegmentIndex = 0
            self.didChangeTabs(self.okSignSegmentBar)
        case .tellFriend:
            self.okSignSegmentBar.selectedSegmentIndex = 1
            self.didChangeTabs(self.okSignSegmentBar)
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.selectedIndex.removeAll()
        self.userCheckFriends.removeAll()
        self.userTellFriends.removeAll()
        self.okSignCollectionView.reloadData()
        getUserOKSignFriends(searchString: nil)
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getOkSignTitle(), for: .normal)
        okSignSegmentBar.setTitle(AppStrings.getCheckFriendString(), forSegmentAt: 0)
        okSignSegmentBar.setTitle(AppStrings.getTellFriendsString(), forSegmentAt: 1)
        self.okSignCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
    }
    
    
    func updateRequestStatus(status: String, userData: Items) {
        
        LifeSignManager.acceptRejectOKSignRequest(friendID: "\(userData.friend_id)", agreement_Status: status, agreement_request: .waiting) { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.setUI()
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func showCancelRequestAlert(userData: Items) {
        // Reject The Request or Cancel The Pending Request
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelRequestString(), style: .destructive, handler: { (_ ) in
            // Hit Cancel Request API
            self.updateRequestStatus(status: .cancel, userData: userData)
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Simply dismiss
        }))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.okSignCollectionView
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserOKSignFriends(searchString: String?) {
        isBeingFetched = true
        LifeSignManager.getOKSignFriendsList(searchString: searchString, limit: nil, PageNumber: nil) { (friendsData, errors, links) in
            self.refreshControl.endRefreshing()
            self.isBeingFetched = false
            if errors == nil {
                self.userCheckFriends.removeAll()
                self.userTellFriends.removeAll()
                
                self.okSignCollectionView.reloadData()
                
                if let userOkFriends = friendsData?.items {
                    
                    for user in userOkFriends {
                        if user.initiator == 1 {
                            self.userCheckFriends.append(user)
                        } else {
                            self.userTellFriends.append(user)
                        }
                    }
                    self.okSignCollectionView.reloadData()
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func showUserFriends() {
        if let controller = R.storyboard.friends.friendsVC() {
            controller.modalPresentationStyle = .overCurrentContext
            controller.mode = .addNew
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    @IBAction func didTapAddFrind(_ sender: UIButton) {
        showUserFriends()
    }
    @IBAction func didTapInfo(_ sender: UIButton) {
        if let controller = R.storyboard.walkThrough.okSignInfoVC() {
            controller.showBackButton = true
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func didChangeTabs(_ sender: UISegmentedControl) {
        self.refresh(sender)
    }
    
    @objc func didTapLeadingButton(_ sender: UIButton) {
        
        sender.showAnimation {
            
        }
        
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[sender.tag] : userTellFriends[sender.tag]
       
        if userData.agreement_request == .accepted {
            self.okSignSegmentBar.selectedSegmentIndex == 0 ? self.sendReminder(atIndex: sender.tag) : self.sendOKSign(atIndex: sender.tag)
        } else if userData.agreement_request == .pending {
            // Accept Request
            self.showSpinner(onView: self.view)
            self.updateRequestStatus(status: .accepted, userData: userData)
        }
    }
    @objc func didTapTrailingButton(_ sender: UIButton) {
        
        sender.showAnimation {
            
        }
        
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[sender.tag] : userTellFriends[sender.tag]
        
        if userData.is_read == 1 && userData.initiator == 1 {
            // Perform GotIt Action
            self.markAgreementSeen(atIndex: sender.tag)
            return
        }
        
        if userData.agreement_request == .waiting {
            self.showCancelRequestAlert(userData: userData)
        } else if userData.agreement_request == .accepted {
            self.okSignSegmentBar.selectedSegmentIndex == 0 ? self.sendReminder(atIndex: sender.tag) : self.sendOKSign(atIndex: sender.tag)
            
        } else if userData.agreement_request == .pending {
            // Reject Request
            self.showSpinner(onView: self.view)
            self.updateRequestStatus(status: .rejected, userData: userData)
        }
    }
}

extension OkSignVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return okSignSegmentBar.selectedSegmentIndex == 0 ? (self.isBeingFetched ? 6 : self.userCheckFriends.count) : (self.isBeingFetched ? 6 : self.userTellFriends.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        
        cell?.leadingButton.tag = indexPath.row
        cell?.trailingButton.tag = indexPath.row
        cell?.stackView.tag = indexPath.row
        
        cell?.leadingButton.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
        cell?.trailingButton.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
        
        cell?.emptyCell()
        
        if (okSignSegmentBar.selectedSegmentIndex == 0) && (self.isBeingFetched){
            cell?.showAnimation()
            return cell ?? FriendsCollectionViewCell()
        }
        if (okSignSegmentBar.selectedSegmentIndex != 0) && (self.isBeingFetched){
            cell?.showAnimation()
            return cell ?? FriendsCollectionViewCell()
        }
        
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[indexPath.row] : userTellFriends[indexPath.row]
        cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: okSignSegmentBar.selectedSegmentIndex == 0 ? .checkFriend : .tellFriend)
        cell?.hideAnimation()
        cell?.userTimeZoneLabel.text = userData.timezone
        cell?.mainButton.tag = indexPath.row
        
        if userData.agreement_request == .waiting {
            cell?.trailingButton.setTitle(AppStrings.getWaitingString(), for: .normal)
        } else if userData.agreement_request == .accepted {
            // Default State
            cell?.trailingButton.backgroundColor = UIColor.appGreenColor
            cell?.cardView.backgroundColor = R.color.appBoxesColor()
            cell?.mainButton.addTarget(self, action: #selector(didTapCardView(_:)), for: .touchUpInside)
            cell?.userNameLabel.textColor = R.color.appLightFontColor()
            cell?.userTimeZoneLabel.textColor = R.color.appLightFontColor()
            // return cell ?? FriendsCollectionViewCell()
        } else if userData.agreement_request == .pending {
            cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: .acceptReject)
            cell?.cardView.backgroundColor = R.color.appBoxesColor()
            cell?.mainButton.addTarget(self, action: #selector(didTapCardView(_:)), for: .touchUpInside)
            cell?.userNameLabel.textColor = R.color.appLightFontColor()
            cell?.userTimeZoneLabel.textColor = R.color.appLightFontColor()
            return cell ?? FriendsCollectionViewCell()
        }
        
        cell?.cardView.backgroundColor = R.color.appBoxesColor()
        cell?.mainButton.addTarget(self, action: #selector(didTapCardView(_:)), for: .touchUpInside)
        cell?.userNameLabel.textColor = R.color.appLightFontColor()
        cell?.userTimeZoneLabel.textColor = R.color.appLightFontColor()
        
        
        // Hanlde Button State
    
        if self.okSignSegmentBar.selectedSegmentIndex == 0 {
            
            // Reminder Tab
            
            if userData.remind_time != "" {
                // Means Show Timer
                
                var nextTime = Date()
                nextTime = userData.remind_time.getDateObjectFromString()
                let nowTime = Date()
                
                if let oneHourAhead = Calendar.current.date(byAdding: .minute, value: Constants.timerInterval, to: nextTime) {
                    if nowTime < oneHourAhead {
                        cell?.buttonContainerView.isHidden = true
                        let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                        let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: oneHourAhead)
                        let onHrTimer = self.componentsFormatter.string(from: components)
                        cell?.userTimeZoneLabel.text = onHrTimer
                        // cell?.userTimeZoneLabel.font = Constants.bigButtonFont
                        if !self.selectedIndex.contains(indexPath) {
                            self.selectedIndex.append(indexPath)
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
                        cell?.buttonContainerView.isHidden = true
                        let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                        let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: oneHourAhead)
                        let onHrTimer = self.componentsFormatter.string(from: components)
                        cell?.userTimeZoneLabel.text = onHrTimer
                        
                        if !self.selectedIndex.contains(indexPath) {
                            self.selectedIndex.append(indexPath)
                        }
                    }
                }
            }
        }
        
        
        // Display GotIt Button => Red State
        
        if userData.is_read == 1 && userData.initiator == 1 {
            cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: .gotIt)
        }
        
        // Display State When Reminder is received => Green State
        
        if userData.initiator == 0 && userData.read_reminder == 1 {
            // Display Reminder Received
            cell?.configureCellForOKSign(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, state: .reminderReceived)
        }
        
        return cell ?? FriendsCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            return CGSize(width: Constants.screenWidth / 3, height: 240)
        }
        else
        {
            return CGSize(width: Constants.screenWidth / 2, height: 240)
        }
    }
    
    @objc func didTapCardView(_ sender: UIButton) {
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[sender.tag] : userTellFriends[sender.tag]
        
        let alertController = UIAlertController(title: nil, message: AppStrings.getDeleteString() + " " + userData.first_name, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: AppStrings.getDeleteString(), style: .destructive, handler: { (_ ) in
            // Perform Delete Agreement
            self.showSpinner(onView: self.view)
            LifeSignManager.removeFromOkAgreement(agreementID: "\(userData.agreement_id)") { (status, errors) in
                NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                self.removeSpinner()
                if errors == nil {
                    self.refresh(sender)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
            
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Simply Dismiss
        }))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.okSignCollectionView
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        if userData.agreement_request == .accepted {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func sendOKSign(atIndex: Int) {
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[atIndex] : userTellFriends[atIndex]
        self.showSpinner(onView: self.view)
        LifeSignManager.sendIAMOKToUSER(agreementID: "\(userData.agreement_id)") { (status, errors) in
            self.removeSpinner()
            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            if errors == nil {
                AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: "\(userData.first_name) \(AppStrings.getNotifiedString())", style: .success, controller: self)
                self.refresh(UIButton())
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    func sendReminder(atIndex: Int) {
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[atIndex] : userTellFriends[atIndex]
        self.showSpinner(onView: self.view)
        LifeSignManager.sendReminderToUser(agreementID: "\(userData.agreement_id)") { (status, errors) in
            self.removeSpinner()
            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            if errors == nil {
                AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: "\(userData.first_name) \(AppStrings.getNotifiedString())", style: .success, controller: self)
                self.refresh(UIButton())
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    func markAgreementSeen(atIndex: Int) {
        let userData = okSignSegmentBar.selectedSegmentIndex == 0 ? userCheckFriends[atIndex] : userTellFriends[atIndex]
        self.showSpinner(onView: self.view)
        LifeSignManager.markAgreementSeen(agreementID: "\(userData.agreement_id)") { (status, errors) in
            self.removeSpinner()
            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            if errors == nil {
                // AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: "\(userData.first_name) \(AppStrings.getNotifiedString())", style: .success, controller: self)
                self.refresh(UIButton())
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
}

