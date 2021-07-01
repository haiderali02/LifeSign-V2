//
//  NotificationVC.swift
//  LifeSign
//
//  Created by Haider Ali on 30/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import EmptyDataSet_Swift
import SwipeCellKit

class NotificationVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var notificationTableView: UITableView! {
        didSet {
            notificationTableView.estimatedRowHeight = 50
            notificationTableView.rowHeight = UITableView.automaticDimension
            notificationTableView.separatorStyle = .none
            
            notificationTableView.register(R.nib.friendsTableViewCell)
        }
    }
    
    // MARK:- PROPERTIES -
    var links: Links?
    var refreshControl = UIRefreshControl()
    var notificationList: [Notifications] = [Notifications]() {
        didSet {
            DispatchQueue.main.async {
                self.notificationTableView.reloadData()
            }
        }
    }
    var currentPage: Int = 1 {
        didSet {
            self.getNotifications(pageNumber: currentPage)
        }
    }
    var isBeingFetched = false {
        didSet {
            notificationTableView.reloadData()
        }
    }
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        notificationTableView.addSubview(refreshControl)
        
        getNotifications()
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getNotificationString(), for: .normal)
        self.notificationTableView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        self.notificationTableView.reloadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.currentPage = 1
    }
    
    func getNotifications(pageNumber: Int = 1) {
        self.isBeingFetched = true
        NotificationManager.getUserNotifications(limit: 50, PageNumber: currentPage) { (notificationData, errors) in
            self.isBeingFetched = false
            self.refreshControl.endRefreshing()
            self.links = notificationData?.links
            
            if errors == nil {
                if self.currentPage == 1 {
                    self.notificationList.removeAll()
                }
                self.notificationList.append(contentsOf: notificationData!.notifications)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    
}

extension NotificationVC: ListViewMethods, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isBeingFetched ? 20 : self.notificationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsTableViewCell, for: indexPath)
        cell?.delegate = self
        if !self.isBeingFetched {
            cell?.removeAnimation()
            let notificationData = self.notificationList[indexPath.row]
            cell?.contentView.backgroundColor = notificationData.status == 0 ? .appBoxColor : .black
            
            cell?.seperatorView.backgroundColor = notificationData.status == 0 ? .white : .white
//            cell?.msgStatusView.isHidden = false
            cell?.msgStatusView.isHidden = notificationData.status != 0 ? true : false
            
            cell?.configureCell(withTitle: notificationData.message, subTitle: notificationData.created_at, userImage: notificationData.profile_image, type: .notification, timeAgo: notificationData.full_name)
            cell?.seperatorView.isHidden = false
        } else {
            cell?.showAnimation()
        }
        
        return cell ?? FriendsTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var obj = self.notificationList[indexPath.row]
        
        
        NotificationManager.markNotificationSeen(notificationID: obj.notification_id) { status, errors in
            if errors == nil {
                return
            }
        }
        
        obj.status = 1
        
        self.notificationList[indexPath.row] = obj
        
        self.notificationTableView.reloadData()
        
        handleNotificationTaped(notification: obj)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.notificationList.count - 1) {
            if let link = links {
                if link.last_page == currentPage {
                    return
                } else {
                    self.currentPage += 1
                }
            }
        }
    }
    
    // MARK:- TABLEVIEW EDIT ACTIONS -
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
            let notificationData = self.notificationList[indexPath.row]
            print("Notification ID: \(notificationData.notification_id)")
            NotificationManager.deleteNotification(notificationID: notificationData.notification_id) { (status, errors) in
                if errors == nil {
                    self.notificationList.remove(at: indexPath.row)
                    self.notificationTableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
        deleteAction.image = R.image.ic_delete()
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.didTapBack(self.backBtn)
        return UISwipeActionsConfiguration()
    }
    
    func handleNotificationTaped(notification: Notifications) {
        switch notification.type {
        case .generalFriendType:
            switch notification.sub_type {
            case .generalFriendRequest, .generalFriendAccept:
                self.navigationController?.popViewControllerWithHandler {
                    NotificationCenter.default.post(name: .redirectToFriends, object: nil)
                }
            default:
                return
            }
        case .gameType:
            self.navigationController?.popViewControllerWithHandler {
                NotificationCenter.default.post(name: .redirectToGame, object: nil)
            }
        case .shopType:
            switch notification.sub_type {
            case .shopSMS:
                self.navigationController?.popViewControllerWithHandler {
                    NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex": 2])
                }
            default:
                return
            }
        case .sosType:
            switch notification.sub_type {
            case .sosRequest, .sosAccept:
                self.navigationController?.popViewControllerWithHandler {
                    NotificationCenter.default.post(name: .openSOSFriends, object: nil)
                }
            case .sosAlert:
                self.navigationController?.popViewControllerWithHandler {
                    NotificationCenter.default.post(name: .openSOSListing, object: nil)
                }
            default:
                return
            }
        case .okSignAgreement:
            switch notification.sub_type {
            case .okAgreementReminder:
                if let controller = R.storyboard.lifeSign.okSignVC() {
                    controller.mode = .tellFriend
                    self.push(controller: controller, animated: true)
                }
            case .okAgreementRequest:
                if let controller = R.storyboard.lifeSign.okSignVC() {
                    controller.mode = .tellFriend
                    self.push(controller: controller, animated: true)
                }
            case .okAgreementI_am_ok:
                if let controller = R.storyboard.lifeSign.okSignVC() {
                    controller.mode = .checkFriend
                    self.push(controller: controller, animated: true)
                }
            default:
                return
            }
        case .dailySignType:
            switch notification.sub_type {
            case .dailySignAccept, .dailySignSwap:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                    self.push(controller: controller, animated: true)
                }
            case .dailySignRequest:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                    self.push(controller: controller, animated: true)
                }
            case .dailySignI_am_safe:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                    self.push(controller: controller, animated: true)
                }
            case .dailySignUpdateTime:
                if let controller = R.storyboard.lifeSign.dailySignVC() {
                    self.push(controller: controller, animated: true)
                }
            default:
                return
            }
        case .shopType:
            switch notification.sub_type {
            case .shopSMS:
                self.navigationController?.popViewControllerWithHandler {
                    NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex": 2])
                }
            default:
                return
            }
        default:
            return
        }
    }
    
}
