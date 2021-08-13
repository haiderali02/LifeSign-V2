//
//  GameVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import SkeletonView
import UnityAds

class GameVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var friendsCollectionView: UICollectionView! {
        didSet {
            friendsCollectionView.delegate = self
            friendsCollectionView.dataSource = self
            friendsCollectionView.register(R.nib.friendsCollectionViewCell)
            friendsCollectionView.register(UINib(resource: R.nib.gameHeaderReusableView), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GameHeaderReusableView")
            friendsCollectionView.isSkeletonable = true
            
        }
    }
    
    
    // MARK:- PROPERTIES -
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    var isBeingFetched = false {
        didSet {
            friendsCollectionView.reloadData()
        }
    }
    var timer: Timer?
    private(set) lazy var refreshControl: UIRefreshControl = {
            let control = UIRefreshControl()
            control.addTarget(self, action: #selector(setUI), for: .valueChanged)
            return control
    }()
    
    
    var userGameFriends: [Items] = [Items]()
    
    var allowedUsers: Int = 0
    
    var selectedIndexToReload: [IndexPath] = [IndexPath]()
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        implementUnityAds()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK:- FUNCTIONS -
    
    func showUserFriends() {
        if let controller = R.storyboard.friends.friendsVC() {
            controller.modalPresentationStyle = .overCurrentContext
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .overFullScreen
            controller.mode = .game
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func implementUnityAds() {
        UnityAds.initialize(Constants.DEV_APP_ID, testMode: Constants.IS_DEV_MODE)
        UnityAds.add(self)
    }
    
    
    func getUserGameFriends() {
        // isBeingFetched = true
        GameManager.getMYGameFriends(searchString: nil, limit: nil, PageNumber: nil) { friendsdata, game_contacts,errors, links in
            self.refreshControl.endRefreshing()
            self.selectedIndexToReload.removeAll()
            self.userGameFriends.removeAll()
        
            if let gameContacts = game_contacts {
                self.allowedUsers = gameContacts
            }
            
            // self.isBeingFetched = false
            if errors == nil {
                guard let userGameFriends = friendsdata?.items else {return}
                self.userGameFriends = userGameFriends
                
                self.friendsCollectionView.reloadData()
                self.friendsCollectionView.collectionViewLayout.invalidateLayout()
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @objc func setUI () {
        /* timer?.invalidate()
        timer = nil */
        self.getUserGameFriends()
       /* timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_ ) in
             self.friendsCollectionView.reloadItems(at: self.selectedIndexToReload)
        } */
        
        SocketHelper.shared.listenGameStartEvent { gameInProgress in
            guard let gameInProg = gameInProgress else {return}
            
            let friendIndex = self.userGameFriends.firstIndex { (friend) -> Bool in
                if let gameID = friend.progress_games?.game_id {
                    return gameID == gameInProg.game_id
                }
                return false
            }
            
            guard let currentFriendIndex = friendIndex else {return}
            let currentUserAtIndex = self.userGameFriends[currentFriendIndex]
            var updatedObject =  currentUserAtIndex
            updatedObject.progress_games = gameInProgress
            
            self.userGameFriends[currentFriendIndex] = updatedObject
            
            let indexPath = IndexPath(item: currentFriendIndex, section: 0)
            
            self.friendsCollectionView.reloadItems(at: [indexPath])
            self.friendsCollectionView.collectionViewLayout.invalidateLayout()
            
        }
        
        
        SocketHelper.shared.listenGameInvitationEvent { items in
            self.selectedIndexToReload.removeAll()
            self.timer = nil
            self.timer?.invalidate()
            self.userGameFriends.removeAll()
            self.friendsCollectionView.reloadData()
            
            guard let friends = items else {return}
            self.userGameFriends = friends
            self.friendsCollectionView.reloadData()
            self.friendsCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    @objc func setText() {
        friendsCollectionView.refreshControl = refreshControl
        
        timer?.invalidate()
        timer = nil
        
        self.getUserGameFriends()
    }
    
    fileprivate func playMyTurn(_ progressGame: UserGameProgress, _ userFriend: Items, _ sender: DesignableButton) {
        
        SocketHelper.shared.sendGameStartEvent(gameID: progressGame.game_id, clickByUser_id: UserManager.shared.user_id, startUserId: progressGame.game_start_by_user_id, friendID: userFriend.friend_id, gameStartTime: progressGame.game_start_time, fcmTokken: userFriend.fcm_token, message: userFriend.message)
        
        
        sender.hideLoading()
       // Helper.sendNotification(toUserFcmTokken: userFriend.fcm_token, text: userFriend.message, title: "HELLO")
        
    }
    
    func handlePlayTurn(_ userFriend: Items, acceptBtn: Bool, sender: DesignableButton) {
         
        guard let progressGame = userFriend.progress_games else {return}
        print("I Am Calling")
        
        if progressGame.utc_time != "" {
            var nextTime = Date()
            nextTime = progressGame.utc_time.getDateObjectFromString()
            let nowTime = Date()
            
            if nowTime > nextTime {
                handleWinOrLossStatus(userFriend, progressGame, nowTime, nextTime)
                sender.hideLoading()
                
            } else {
                if progressGame.click_by_user_id == UserManager.shared.user_id {
                    print("Opponent Turn")
                } else {
                    // Play My Turn
                    playMyTurn(progressGame, userFriend, sender)
                }
            }
        } else {
            sender.hideLoading()
        }
    }
    
    
    func updateRequestStatus(status: String, userFriend: Items) {
        self.showSpinner(onView: self.view)
        GameManager.acceptRejectGameFriendRequest(friendID: userFriend.friend_id, gameRequestStatus: status) { reqStatus, errors in
            self.removeSpinner()
            if errors == nil {
                 
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .reloadGameScreen, object: nil)
    }
    
    fileprivate func handleWinOrLossStatus(_ userFriend: Items,_ prgressGame: UserGameProgress, _ nowTime: Date, _ nextTime: Date) {
        
        if prgressGame.click_by_user_id == UserManager.shared.user_id {
            // Opponent Turn
            if nowTime > nextTime {
                // I Won The Game
                print("I WON - RESEND GAME INVITE")
                GameManager.sendGameRequestToFriend(friend_ID: userFriend.friend_id) { status, errors in
                    if errors == nil {
                        self.getUserGameFriends()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            }
        } else {
            // My Turn
            if nowTime > nextTime {
                print("I LOSS - RESEND GAME INVITE")
                GameManager.sendGameRequestToFriend(friend_ID: userFriend.friend_id) { status, errors in
                    if errors == nil {
                        self.getUserGameFriends()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            }
        }
    }
    
    
    // MARK:- ACTIONS -
    
    @objc func didTapEnableAutoClick(_ sender: UIButton) {
        sender.showAnimation {
            sender.isSelected = !sender.isSelected
            GameManager.enableAutoClicks(enableClics: sender.isSelected ? 1 : 0) { _, _ in
                self.friendsCollectionView.reloadData()
                self.friendsCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    @objc func didTapBuyMoreAutoClicks(_ sender: UIButton) {
        sender.showAnimation {
            NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex":1])
        }
    }
    
    @objc func didTapWatchAd(_ sender: UIButton) {
        sender.showAnimation {
            UnityAds.show(self, placementId: Constants.DEV_VIDE_AD_PLACEMENT, showDelegate: self)
        }
    }
    @objc func didTapBuyMoreGames(_ sender: UIButton) {
        sender.showAnimation {
            NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex":1])
        }
    }
    
    @objc func didTapBuyMore(_ sender: UIButton) {
        sender.showAnimation {
            NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex":1])
        }
    }
    
    @objc func showHitList(_ sender: UIButton) {
        sender.showAnimation {
            guard let leaderBoard = R.storyboard.game.leaderBoardVC() else {return}
            self.push(controller: leaderBoard, animated: true)
        }
    }
    
    @objc func didTapLeadingButton(_ sender: DesignableButton) {
        // Accept Request
        sender.showAnimation {
            sender.showLoading()
            
            if !(sender.tag <= self.userGameFriends.count) {
                sender.hideLoading()
                return
            }
            
            let gameFriend = self.userGameFriends[sender.tag]
            
            if gameFriend.game_request == .waiting {
                ///
                // MARK:- Cancel GAME FRIEND Request -
                //
                GameManager.acceptRejectGameFriendRequest(friendID: gameFriend.friend_id, gameRequestStatus: .cancel) { status, errors in
                    sender.hideLoading()
                    if errors == nil {
                        self.getUserGameFriends()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }

            } else if gameFriend.game_request == .pending {
                //
                // MARK:- ACCEPT FRIEND GAME REQUEST -
                //
                
                GameManager.acceptRejectGameFriendRequest(friendID: gameFriend.friend_id, gameRequestStatus: .accepted) { status, errors in
                    sender.hideLoading()
                    if errors == nil {
                        self.getUserGameFriends()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            } else if gameFriend.game_request == .accepted {
                
                // GAME FRIEND REQUEST IS ACCEPTED - NOW HANDLE FURTHER CASES
                
                if gameFriend.game_start_status == .start {
                    //
                    // MARK: - GAME IS IN PROGRESS , HANDLE TURN PLAY -
                    //
                    sender.showLoading()
                    self.handlePlayTurn(gameFriend, acceptBtn: true, sender: sender)
                    
                } else if gameFriend.game_start_status == .free {
                    //
                    // MARK:- SEND GAME PLAY FRIEND REQUEST -
                    //
                    GameManager.sendGameRequestToFriend(friend_ID: gameFriend.friend_id) { status, errors in
                        sender.hideLoading()
                        if errors == nil {
                            self.getUserGameFriends()
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                    }
                } else if (gameFriend.game_request == .accepted) && (gameFriend.game_start_status == .pending) {
                    //
                    // MARK:- ACCEPT GAME PLAY INVITE -
                    //
                    // self.isBeingFetched = true
                    GameManager.acceptRejectGameRequestFromFriend(friendID: gameFriend.friend_id, gameRequestStatus: .accepted) { userGameFriendsReceived, errors, links in
                        sender.hideLoading()
                        if errors == nil {
                            guard let userGameFriends = userGameFriendsReceived?.items else {return}
                            self.userGameFriends = userGameFriends
                            self.friendsCollectionView.reloadData()
                            self.friendsCollectionView.collectionViewLayout.invalidateLayout()
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                    }
                } else if (gameFriend.game_request == .accepted) && (gameFriend.game_start_status == .waiting) {
                    //
                    // MARK:- CANCEL SENT INVITE -
                    // self.isBeingFetched = true
                    GameManager.acceptRejectGameRequestFromFriend(friendID: gameFriend.friend_id, gameRequestStatus: .rejected) { userGameFriendsReceived, errors, links in
                        sender.hideLoading()
                        
                        if errors == nil {
                            guard let userGameFriends = userGameFriendsReceived?.items else {return}
                            self.userGameFriends = userGameFriends
                            self.friendsCollectionView.reloadData()
                            self.friendsCollectionView.collectionViewLayout.invalidateLayout()
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                        
                    }
                }
                
            } else {
                sender.hideLoading()
                // self.handleUserFriend(gameFriend, acceptBtn: true)
            }
        }
    }
    @objc func didTapTrailingButton(_ sender: DesignableButton) {
        sender.showAnimation {
            sender.showLoading()
            if (sender.tag > self.userGameFriends.count) || (sender.tag == self.userGameFriends.count) {
                self.showUserFriends()
                sender.hideLoading()
                return
            }
            
            let gameFriend = self.userGameFriends[sender.tag]
            if gameFriend.game_request == .waiting {
                //
                // MARK:- CANCEL GAME FRIEND SENT REQUEST -
                //
                GameManager.acceptRejectGameFriendRequest(friendID: gameFriend.friend_id, gameRequestStatus: .cancel) { status, errors in
                    sender.hideLoading()
                    if errors == nil {
                        self.getUserGameFriends()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
                
            } else if gameFriend.game_request == .pending {
                //
                // MARK:- REJECT GAME FRIEND RECEIVED REQUEST -
                //
                
                GameManager.acceptRejectGameFriendRequest(friendID: gameFriend.friend_id, gameRequestStatus: .rejected) { status, errors in
                    sender.hideLoading()
                    if errors == nil {
                        self.getUserGameFriends()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
                
            } else if (gameFriend.game_request == .accepted) && (gameFriend.game_start_status == .pending) {
                //
                // MARK:- REJECT RECEIVED GAME PLAY INVITATION -
                //
                
                // self.isBeingFetched = true
                GameManager.acceptRejectGameRequestFromFriend(friendID: gameFriend.friend_id, gameRequestStatus: .rejected) { userGameFriendsReceived, errors, links in
                    sender.hideLoading()
                    if errors == nil {
                        guard let userGameFriends = userGameFriendsReceived?.items else {return}
                        self.userGameFriends = userGameFriends
                        self.friendsCollectionView.reloadData()
                        self.friendsCollectionView.collectionViewLayout.invalidateLayout()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                    
                }
            }  else if (gameFriend.game_request == .accepted) && (gameFriend.game_start_status == .waiting) {
                //
                // MARK:- CANCEL GAME PLAY SENT INVITATION -
                //
                
                // self.isBeingFetched = true
                GameManager.acceptRejectGameRequestFromFriend(friendID: gameFriend.friend_id, gameRequestStatus: .rejected) { userGameFriendsReceived, errors, links in
                    sender.hideLoading()
                    if errors == nil {
                        guard let userGameFriends = userGameFriendsReceived?.items else {return}
                        self.userGameFriends = userGameFriends
                        self.friendsCollectionView.reloadData()
                        self.friendsCollectionView.collectionViewLayout.invalidateLayout()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                    
                }
            } else if (gameFriend.game_request == .accepted) && (gameFriend.game_start_status == .free) {
                
                //
                // MARK:- REMOVE GAME FRIEND -
                //
                
                let confirmationController = UIAlertController(title: AppStrings.areYouSureString(), message: AppStrings.willTakeExtraPokeGame(), preferredStyle: .alert)
                
                confirmationController.addAction(UIAlertAction(title: AppStrings.YESString(), style: .destructive, handler: { _  in
                    //
                    self.showSpinner(onView: self.friendsCollectionView)
                    GameManager.removeGameFriend(friendID: gameFriend.friend_id) { status, errors in
                        self.removeSpinner()
                        sender.hideLoading()
                        if errors == nil {
                            self.getUserGameFriends()
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                    }
                }))
                
                confirmationController.addAction(UIAlertAction(title: AppStrings.NOString(), style: .default, handler: { _  in
                    // SIMPLE DISMISS
                    sender.hideLoading()
                }))
                self.present(confirmationController, animated: true, completion: nil)
                
            }
        }
    }
}



extension GameVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let unlimitedGamePurchased = UserManager.shared.userResources?.game_contact_unlimited else {return 0}
        if unlimitedGamePurchased {
            return self.isBeingFetched ? 3 : (self.userGameFriends.count + 1) // +1 is For Add new
        } else {
            return self.isBeingFetched ? 3 : (self.userGameFriends.count + self.allowedUsers) // +1 is For Add new
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        cell?.leadingButton.tag = indexPath.row
        cell?.trailingButton.tag = indexPath.row
        cell?.stackView.tag = indexPath.row
        
        cell?.leadingButton.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
        cell?.trailingButton.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
        
        
        cell?.cardView.tag = indexPath.row
        cell?.buttonContainerView.isHidden = true
        
        cell?.countDownTimer?.invalidate()
        cell?.countDownTimer = nil
        
        cell?.mainButton.tag = indexPath.row
        cell?.mainButton.isHidden = true
        cell?.mainButton.addTarget(self, action: #selector(didTapCardView(_:)), for: .touchUpInside)
        cell?.delegate = self
        cell?.userImageView.image = nil
        cell?.userNameLabel.text = nil
        
        if (indexPath.row > userGameFriends.count) || (indexPath.row == userGameFriends.count) {
            cell?.hideAnimation()
            cell?.emptyCell()
            cell?.configureGameAddCell()
            return cell ?? FriendsCollectionViewCell()
        } else {
            cell?.emptyCell()
            let gameFriend = self.userGameFriends[indexPath.row]
           /* if let gameObj = gameFriend.progress_games {
                if gameObj.current_hit_time != "" {
                    if !self.selectedIndexToReload.contains(indexPath) {
                        self.selectedIndexToReload.append(indexPath)
                    }
                }
            } */
            cell?.configureGameFriendCell(withName: gameFriend.full_name, userImage: gameFriend.profile_image, userFriend: gameFriend)
            
            
            if let isGameOver = cell?.isGameOver {
                if isGameOver {
                    self.selectedIndexToReload.removeAll { arrayIndex in
                        arrayIndex == indexPath
                    }
                }
            }
            return cell ?? FriendsCollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            return CGSize(width: Constants.screenWidth / 3, height: 230)
        }
        else
        {
            return CGSize(width: Constants.screenWidth / 2, height: 230)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GameHeaderReusableView", for: indexPath) as! GameHeaderReusableView
        
        switch kind {
        
        case UICollectionView.elementKindSectionHeader:
            
            headerView.btnWatchAd.addTarget(self, action: #selector(didTapWatchAd(_:)), for: .touchUpInside)
            headerView.btnAutoClickEnable.addTarget(self, action: #selector(didTapEnableAutoClick(_:)), for: .touchUpInside)
            headerView.btnBuyMore.addTarget(self, action: #selector(didTapBuyMoreAutoClicks(_:)), for: .touchUpInside)
            headerView.btnBuyMoreGames.addTarget(self, action: #selector(didTapBuyMoreGames(_:)), for: .touchUpInside)
            headerView.hitlisteButton.addTarget(self, action: #selector(showHitList(_:)), for: .touchUpInside)
            return headerView
        default:
            assert(false, "Unexpected element kind")
            return headerView
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.friendsCollectionView.frame.width, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    @objc func didTapCardView(_ sender: UIButton) {
        
    }
}



extension GameVC: UADSBannerViewDelegate, UnityAdsDelegate, UnityAdsShowDelegate {
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        print("Ads Completed: \(placementId)")
        
        switch state {
        case .showCompletionStateCompleted:
            print("Add Completed")
            GameManager.earnReward(rewardType: .rewardAutoClicks) { status, errors in
                if errors == nil {
                    AlertController.showAlert(witTitle: AppStrings.getCongratsString(), withMessage: AppStrings.getReawardedClicks(), style: .success, controller: self)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
            
        case .showCompletionStateSkipped:
            print("Add Skipped")
        default:
            return
        }
        
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        print("Ads Failed To Display: \(placementId)")
    }
    
    func unityAdsShowStart(_ placementId: String) {
        print("Ads Display Started: \(placementId)")
    }
    
    func unityAdsShowClick(_ placementId: String) {
        print("Ads Display Clicked: \(placementId)")
    }
    
    
    func unityAdsReady(_ placementId: String) {
        print("Ad Ready With ID: \(placementId)")
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        print("Error Loading Unity Ad: \(message)")
    }
    
    func unityAdsDidStart(_ placementId: String) {
        print("Ad Started With ID: \(placementId)")
    }
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        print("Ad Finished With ID: \(placementId)")
    }
}

extension GameVC: FriendCollectionViewDelegate {
    
    func autoPlayMyTurn(play: Bool, progressGame: UserGameProgress, userFriend: Items) {
        if play {
            if progressGame.utc_time != "" {
                var nextTime = Date()
                nextTime = progressGame.utc_time.getDateObjectFromString()
                let nowTime = Date()
                nextTime = progressGame.utc_time.getDateObjectFromString()
                if let timer = Calendar.current.date(byAdding: .minute, value: 0, to: nextTime) {
                    let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                    let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: timer)
                    if let secondsInComponents = components.second,
                       let hrsInComponent = components.hour,
                       let minutes = components.minute
                       {
                        if hrsInComponent < 1 && minutes < 1 && secondsInComponents < 59 {
                            SocketHelper.shared.sendGameStartEvent(gameID: progressGame.game_id, clickByUser_id: UserManager.shared.user_id, startUserId: progressGame.game_start_by_user_id, friendID: userFriend.friend_id, gameStartTime: progressGame.game_start_time, fcmTokken: userFriend.fcm_token, message: userFriend.message)
                        }
                    }
                }
            }
        } else {
            return
        }
    }
    
    func shouldReloadWith(isCurrentUserWon: Bool) {
        if isCurrentUserWon {
            self.setText()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.setText()
            }
        }
    }
}
