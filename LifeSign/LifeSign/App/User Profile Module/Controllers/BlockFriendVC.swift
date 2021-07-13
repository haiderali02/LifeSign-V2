//
//  BlockFriendVC.swift
//  LifeSign
//
//  Created by Haider Ali on 19/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import EmptyDataSet_Swift

class BlockFriendVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var userTableView: UITableView! {
        didSet {
            userTableView.estimatedRowHeight = 80
            userTableView.rowHeight = UITableView.automaticDimension
            userTableView.separatorStyle = .none
            userTableView.register(R.nib.friendsTableViewCell)
        }
    }
    
    // MARK:- PROPERTIES -
    
    var paginationLinks: Links?
    var refreshControl = UIRefreshControl()
    var userFriendsData: [Items] = [Items]()
    var isBeingFetched = false {
        didSet {
            userTableView.reloadData()
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
        
        getUserFriends(searcString: nil)
    }
    
    func getUserFriends(searcString: String?, pageNumer: Int = 0, userLimit: Int? = 20) {
        isBeingFetched = true
        FriendManager.getUserFriends(searchString: searcString, limit: userLimit, PageNumber: pageNumer, friend_Status: .blocked) { (friendsData, errors, links) in
            self.isBeingFetched = false
            self.removeSpinner()
            if errors == nil {
                guard let userFriends = friendsData?.items else {
                    self.refreshControl.endRefreshing()
                    if !(pageNumer > 1) {
                        self.userFriendsData.removeAll()
                    }
                    self.userTableView.reloadData()
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
                self.refreshControl.endRefreshing()
                self.userTableView.reloadData()
            } else {
                self.refreshControl.endRefreshing()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getBlockedFriends(), for: .normal)
        self.userTableView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    
    @objc func didTapUnblocked(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        
        let userFreind = self.userFriendsData[sender.tag]
        
        FriendManager.acceptRejectFriendRequest(requestStatus: .accepted, requestID: "\(userFreind.friend_request_id)") { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.getUserFriends(searcString: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
}

extension BlockFriendVC: ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isBeingFetched ? 10 : self.userFriendsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsTableViewCell, for: indexPath)
        
        if !isBeingFetched {
            friendCell?.removeAnimation()
            let userData = self.userFriendsData[indexPath.row]
            
            friendCell?.providerImage.image = nil
            
            if userData.provider == .app {
                friendCell?.providerImage.image = R.image.ic_email_head()
            } else if userData.provider == .facebook {
                friendCell?.providerImage.image = R.image.ic_facebook_headd()
            } else if userData.provider == .apple {
                friendCell?.providerImage.image = R.image.ic_apple_head()
            }
            
            friendCell?.configureCell(withTitle: userData.first_name + " " + userData.last_name, subTitle: userData.timezone, userImage: userData.profile_image, type: .myFriend, userRequestStatus: nil)
            friendCell?.trailingButton.tag = indexPath.row
            friendCell?.trailingButton.setTitle(AppStrings.getUnblockedString(), for: .normal)
            
            friendCell?.trailingButton.addTarget(self, action: #selector(didTapUnblocked(_:)), for: .touchUpInside)
        } else {
            friendCell?.showAnimation()
        }
    
        return friendCell ?? FriendsTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
