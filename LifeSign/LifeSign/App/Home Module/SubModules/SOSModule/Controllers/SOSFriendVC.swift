//
//  SOSFriendVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import MaterialComponents
import EmptyDataSet_Swift


class SOSFriendVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var friendCollectionView: UICollectionView! {
        didSet {
            friendCollectionView.delegate = self
            friendCollectionView.dataSource = self
            friendCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    var userFriendsData: [Items] = [Items]()
    var paginationLinks: Links?
    var refreshControl = UIRefreshControl()
    
    var isBeingFetched = false {
        didSet {
            friendCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observerLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        setText()
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        self.getUserSOSFriends(searcString: nil)
        self.friendCollectionView!.alwaysBounceVertical = true
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        friendCollectionView.addSubview(refreshControl)
    }
    
    @objc func setText() {
        self.friendCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getUserSOSFriends(searcString: nil)
    }
    
    func updateRequestStatus(status: String, userFriend: Items) {
        self.showSpinner(onView: self.view)
        SOSManager.acceptRejectSOSRequest(friendID: "\(userFriend.friend_id)", sos_status: status, sos_request: userFriend.sos_request) { (status, errors) in
            self.removeSpinner()
            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            if errors == nil {
                self.getUserSOSFriends(searcString: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func getUserSOSFriends(searcString: String?, pageNumer: Int = 0, userLimit: Int? = 20) {
        self.isBeingFetched = true
        SOSManager.getSOSFriendsList(searchString: searcString, limit: userLimit, PageNumber: pageNumer) { (friendsData, errors, links) in
            self.isBeingFetched = false
            self.refreshControl.endRefreshing()
            if errors == nil {
                guard let userFriends = friendsData?.items else {
                    self.refreshControl.endRefreshing()
                    if !(pageNumer > 1) {
                        self.userFriendsData.removeAll()
                    }
                    self.friendCollectionView.reloadData()
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
                self.friendCollectionView.reloadData()
            } else {
                self.refreshControl.endRefreshing()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    
    // MARK:- ACTIONS -
    
    @objc func didTapLeadingButton(_ sender: UIButton) {
        // Accept Request
        sender.showAnimation {
            let userFriend = self.userFriendsData[sender.tag]
            
            if userFriend.sos_request == .waiting {
                self.updateRequestStatus(status: .cancel, userFriend: userFriend)
            } else {
                self.updateRequestStatus(status: .accepted, userFriend: userFriend)
            }
            
        }
        
    }
    @objc func didTapTrailingButton(_ sender: UIButton) {
        
        sender.showAnimation {
            
            if sender.tag >= self.userFriendsData.count {
                NotificationCenter.default.post(name: .redirectToFriends, object: nil)
                return
            }
            
            
            let userFriend = self.userFriendsData[sender.tag]
            
            // Reject The Request or Cancel The Pending Request
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: AppStrings.getCancelRequestString(), style: .destructive, handler: { (_ ) in
                // Hit Cancel Request API
                self.updateRequestStatus(status: .cancel, userFriend: userFriend)
            }))
            alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
                // Simply dismiss
            }))
            
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.friendCollectionView
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            if userFriend.sos_request == .waiting {
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.updateRequestStatus(status: .rejected, userFriend: userFriend)
            }
        }
    }
}

extension SOSFriendVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isBeingFetched ? 6 : (self.userFriendsData.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        
        
        cell?.leadingButton.tag = indexPath.row
        cell?.trailingButton.tag = indexPath.row
        cell?.stackView.tag = indexPath.row
        
        cell?.leadingButton.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
        cell?.trailingButton.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
        
        cell?.mainButton.tag = indexPath.row
        cell?.mainButton.addTarget(self, action: #selector(didTapCardView(_:)), for: .touchUpInside)
        cell?.emptyCell()
        
        if !self.isBeingFetched {
            
            cell?.hideAnimation()
            if indexPath.row >= userFriendsData.count {
                cell?.configureGameAddCell()
                
                var getFriendString = AppStrings.getFriendsString()
                
                if getFriendString.last == "s" {
                    getFriendString.removeLast()
                }
                
                cell?.userTimeZoneLabel.text = AppStrings.getSOSTitle() + " " + getFriendString
                cell?.userNameLabel.isHidden = false
                cell?.userNameLabel.text = AppStrings.getAddNewString()
                return cell ?? FriendsCollectionViewCell()
            }
            
            cell?.hideAnimation()
            
            let userFriend = self.userFriendsData[indexPath.row]
            
            if userFriend.sos_request == .accepted {
                
                // You are Now SOS Friends
                
                cell?.configureCell(withName: userFriend.first_name + " " + userFriend.last_name, userImage: userFriend.profile_image)
                cell?.userTimeZoneLabel.text = userFriend.timezone
                cell?.buttonContainerView.isHidden = true
                
            } else if userFriend.sos_request == .waiting {
                
                // Request Sent & You are waiting
                cell?.buttonContainerView.isHidden = false
                cell?.configureCell(withName: userFriend.first_name + " " + userFriend.last_name, userImage: userFriend.profile_image)
                
                cell?.cardView.backgroundColor = R.color.appOrangeColor()
                cell?.trailingButton.isHidden = true
                cell?.leadingButton.setTitle(AppStrings.getCancelRequestString(), for: .normal)
                cell?.leadingButton.isHidden = false
                cell?.userNameLabel.textColor = .white
                cell?.userTimeZoneLabel.textColor = .white
                cell?.userTimeZoneLabel.text = userFriend.timezone
                cell?.leadingButton.setTitleColor(.white, for: .normal)
                cell?.leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.2)
                
                
            } else if userFriend.sos_request == .pending {
                
                // Request Received - Accept or Reject
                cell?.buttonContainerView.isHidden = false
                cell?.configureCell(withName: userFriend.first_name + " " + userFriend.last_name, userImage: userFriend.profile_image)
                cell?.configureLeadingTrailingButtonCell(leadingButtonName: AppStrings.getAcceptString(), trailingButtonName: AppStrings.getRejectString(), subtitle: userFriend.timezone)
                
            }
            
        } else {
            cell?.showAnimation()
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
        
        if sender.tag >= self.userFriendsData.count {
            NotificationCenter.default.post(name: .redirectToFriends, object: nil)
            return
        }
        
        let userFriend = self.userFriendsData[sender.tag]
        if userFriend.sos_request == .accepted {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: AppStrings.getDeleteString() + " " + userFriend.first_name, style: .destructive, handler: { (_ ) in
                
                self.updateRequestStatus(status: .rejected, userFriend: userFriend)
            }))
            alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
                // Simply dismiss
            }))
            
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.friendCollectionView
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
