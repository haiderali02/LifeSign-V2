//
//  InboxVC.swift
//  LifeSign
//
//  Created by Haider Ali on 22/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import SwipeCellKit

class InboxVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK:- PROPERTIES -
    @IBOutlet weak var myFriendsCollectionView: UICollectionView! {
        didSet {
            myFriendsCollectionView.delegate = self
            myFriendsCollectionView.dataSource = self
            myFriendsCollectionView.register(R.nib.inboxCollectionCell)
        }
    }
    @IBOutlet weak var recentChatTableView: UITableView! {
        didSet {
            recentChatTableView.estimatedRowHeight = 50
            recentChatTableView.rowHeight = UITableView.automaticDimension
            recentChatTableView.separatorStyle = .none
            recentChatTableView.dataSource = self
            recentChatTableView.delegate = self
            recentChatTableView.register(R.nib.friendsTableViewCell)
        }
    }
    var links: Links?
    var refreshControl = UIRefreshControl()
    
    var inboxFriends : [InboxFriendModel] = [InboxFriendModel]()
    var inboxMessages: [InboxMessageModel] = [InboxMessageModel]()
    
    var currentPage: Int = 1 {
        didSet {
            // self.getRecentFriendsChat(pageNumber: currentPage)
        }
    }
    
    var isFetching: Bool = false {
        didSet {
            recentChatTableView.reloadData()
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
        recentChatTableView.addSubview(refreshControl)
        // self.showSpinner(onView: self.view)
        searchBar.searchTextField.addTarget(self, action: #selector(handleSearchBar), for: .editingChanged)
        isFetching = true
        self.getInboxData(pageNumber: self.currentPage, searchString: "")
        
       // SocketHelper.shared.updateUserOnlineStatus()
    }
    
    @objc func handleSearchBar() {
        NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(self.getTextFromSearchField),
            object: searchBar.searchTextField)
            self.perform(
                #selector(self.getTextFromSearchField),
                with: searchBar.searchTextField,
                afterDelay: 0.5)
    }
    
    @objc func getTextFromSearchField(textField: UITextField) {
        guard let searchString = textField.text else {return}
        print("Text: \(searchString)")
        
        self.getInboxData(pageNumber: currentPage, searchString: searchString)
        
        // self.handleSearch(searchString: searchString)
    }
    
    
    fileprivate func setOnlineFriend(_ objects: [Int]) {
        for id in objects {
            
            if inboxFriends.contains(where: { (friend) -> Bool in
                friend.friend_id == id
            }) {
                let friendIndex = self.inboxFriends.firstIndex { (friend) -> Bool in
                    friend.friend_id == id
                }
                
                if let index = friendIndex {
                    let friendAtIndex = self.inboxFriends[index]
                    var updatedFriend = friendAtIndex
                    updatedFriend.is_online = true
                    self.inboxFriends[index] = updatedFriend
                    
                }
            }
        }
        
        self.inboxFriends = self.inboxFriends.sorted(by: { (obj1, obj2) -> Bool in
            return obj1.is_online
        })
        self.myFriendsCollectionView.reloadData()
    }
    
    fileprivate func setAllFriendsOffline() {
        for (index, _) in self.inboxFriends.enumerated() {
            // print("Set Offline: \(friends.full_name)")
            var newFriend = self.inboxFriends[index]
            newFriend.is_online = false
            self.inboxFriends[index] = newFriend
            self.myFriendsCollectionView.reloadData()
        }
    }
    
    @objc func updateFriendsOnlineStatus(_ notification: NSNotification) {
        guard let objects = notification.object as? [Int] else {return}
        print("Onine Users: \(objects)")
        if inboxFriends.count > 0 {
            setAllFriendsOffline()
            setOnlineFriend(objects)
        }
    }
    
    
    func getInboxData(pageNumber: Int, searchString: String) {
        self.isFetching = true
        ChatManager.getUserInbox(searchString: searchString) { inboxResp, errors  in
            self.removeSpinner()
            self.isFetching = false
            self.refreshControl.endRefreshing()
            if errors == nil {
                guard let resp = inboxResp else {return}
                
                if resp.success {
                    if let inBoxFriends = resp.inboxBaseData?.friends?.inboxFriends {
                        self.inboxFriends = inBoxFriends
                        self.myFriendsCollectionView.reloadData()
                    }
                    if let inboxMessages = resp.inboxBaseData?.messages?.inboxMessages {
                        self.inboxMessages = inboxMessages.sorted(by: { msg1, msg2 in
                            return msg1.is_read == false
                        })
                        self.recentChatTableView.reloadData()
                    }
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getMessaesString(), for: .normal)
        self.searchBar.searchTextField.placeholder  = AppStrings.getSearchString()
    }
    @objc func refresh(_ sender: AnyObject) {
        self.currentPage = 1
        self.getInboxData(pageNumber: currentPage, searchString: "")
    }
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInbox(_:)), name: .getInboxLatestData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: .reloadInbox, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFriendsOnlineStatus(_:)), name: .getOnlineLatestUsers, object: nil)
    }
    
    @objc func updateInbox(_ notification: NSNotification) {
        guard let data = notification.object as? [String: Any],
              let inboxData = data["inbox"] as? [Any]
        else {return}
        self.inboxMessages.removeAll()
        for items in inboxData {
            
            if let inboxMsg = items as? [String: Any] {
                if let inboxItem = InboxMessageModel(JSON: inboxMsg) {
                    self.inboxMessages.append(inboxItem)
                }
            }
        }
        
        self.inboxMessages = self.inboxMessages.sorted(by: { msg1, msg2 in
            return msg1.is_read == false
        })
        
        self.recentChatTableView.reloadData()
    }
    
    func showUserFriends() {
        if let controller = R.storyboard.friends.friendsVC() {
            controller.modalPresentationStyle = .overCurrentContext
            controller.mode = .Inbox
            controller.delegates = self
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .overFullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapAddMoreChatFriends(_ sender: UIButton) {
        showUserFriends()
    }
    @IBAction func didTapNewChat(_ sender: UIButton) {
        showUserFriends()
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
}

extension InboxVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inboxFriends.count == 0 ? 6 : inboxFriends.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.inboxCollectionCell, for: indexPath)
        
        if inboxFriends.count == 0 {
            cell?.showAnimation()
        } else {
            cell?.hideAnimation()
            let myFriend = inboxFriends[indexPath.row]
            cell?.configureUserFriend(name: myFriend.full_name, userImage: myFriend.profile_image, onlineStatus: myFriend.is_online)
        }
        
        
        return cell ?? UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let chatVC = R.storyboard.chatBoard.chatVC() {
            
            if self.inboxFriends.count == 0 {return}
            
            let myFriend = inboxFriends[indexPath.row ]
            
            chatVC.userFriend = myFriend
            self.push(controller: chatVC, animated: true)
        }
    }
}

extension InboxVC: ListViewMethods, SwipeTableViewCellDelegate, FriendsVCDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFetching ? 10 : inboxMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsTableViewCell, for: indexPath)
        cell?.delegate = self
        
        if isFetching {
            cell?.showAnimation()
            return cell ?? FriendsTableViewCell()
        } else {
            cell?.removeAnimation()
            let messages = inboxMessages[indexPath.row]
            if messages.is_sent == true {
                cell?.msgStatusView.isHidden = true
            } else {
                cell?.msgStatusView.isHidden = messages.is_read
            }
            
            cell?.configureCell(withTitle: messages.full_name, subTitle: messages.message, userImage: messages.profile_image, type: .inboxListing, userRequestStatus: nil, timeAgo: messages.sent_at)
            return cell ?? FriendsTableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.didTapBack(self.backBtn)
        return UISwipeActionsConfiguration()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (inboxMessages.count - 1) {
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
            // Perform Delete Action
            let messages = self.inboxMessages[indexPath.row]
            self.showSpinner(onView: self.view)
            
            ChatManager.deleteChat(friend_id: messages.user_id) { baseResponse, errors in
                self.removeSpinner()
                if errors == nil {
                    self.refresh(self.refreshControl)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
            
        }
        deleteAction.image = R.image.ic_delete()
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chatVC = R.storyboard.chatBoard.chatVC() {
            if inboxMessages.count == 0 {return}
            let messages = inboxMessages[indexPath.row]
            
            let onlineFriend = self.inboxFriends.first { (ibFriend) -> Bool in
                ibFriend.friend_id == messages.user_id
            }
            let friend = InboxFriendModel(JSON: ["friend_id":messages.user_id, "is_online": onlineFriend?.is_online ?? false,"profile_image": messages.profile_image, "full_name": messages.full_name])
            chatVC.userFriend = friend
            self.push(controller: chatVC, animated: true)
        }
    }
    
    func didSelectFriend(userFriend: Items) {
        if let chatVC = R.storyboard.chatBoard.chatVC() {
            
            let onlineFriend = self.inboxFriends.first { (ibFriend) -> Bool in
                ibFriend.friend_id == userFriend.user_id
            }
            let friend = InboxFriendModel(JSON: ["friend_id":userFriend.user_id, "is_online": onlineFriend?.is_online ?? false,"profile_image": userFriend.profile_image, "full_name": userFriend.first_name + " " + userFriend.last_name])
            chatVC.userFriend = friend
            self.push(controller: chatVC, animated: true)
        }
    }
    
}
