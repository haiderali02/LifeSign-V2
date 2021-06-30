//
//  ChatVC.swift
//  LifeSign
//
//  Created by Haider Ali on 22/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import MessageKit
import InputBarAccessoryView
import YPImagePicker
import IQKeyboardManagerSwift
import ImageViewer_swift
import Lightbox

class ChatVC: MessagesViewController {
    
    // MARK:- OUTLETS -
    
    // MARK:- PROPERTIES -
    var currentUser: Sender = Sender(senderId: "01", displayName: "John Doe")
    var otherUser: Sender = Sender(senderId: "02", displayName: "Daisy John")
    var messages: [Message] = [Message]() {
        didSet {
            self.messagesCollectionView.reloadData()
           
        }
    }
    var isMessageSelected: Bool = false
    var messagesFromServer: [InboxMessageModel] = [InboxMessageModel]()
    
    private(set) lazy var refreshControl: UIRefreshControl = {
            let control = UIRefreshControl()
            control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
            return control
    }()
    
    var picker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.albumName = "LifeSign"
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0
        return YPImagePicker(configuration: config)
    }()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var headerView: HeaderView = {
        let view = HeaderView()
        return view
    }()
    var userFriend: InboxFriendModel?
    
    var currentPage: Int = 1
    var lastPage: Int = 0
    
    var isCurrentUserSubcribed: Bool = false
    
    var isAllMessagesRead: Bool = false {
        didSet{
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
    var charactersCountLabel: UILabel = {
       let label = UILabel()
        label.font = Constants.labelFont
        label.textAlignment = .right
        label.text = "0/140"
       return label
    }()
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // SocketHelper.shared.updateUserOnlineStatus()
        SocketHelper.shared.getFriendTypingStatus() { isTyping in
            guard let typing = isTyping else {return}
            
            self.setTypingIndicatorViewHidden(!typing, animated: true)
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
        
        SocketHelper.shared.setMessagesRead(friendID: UserManager.shared.user_id) { seenMessages in
            
            for msg in seenMessages {
                guard let msgObj = msg as? [String: Any], let msgRead = msgObj["is_read"] as? Bool else {return}
                self.isAllMessagesRead = msgRead
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        navigationItem.title = nil
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.post(name: .reloadInbox, object: nil)
        SocketHelper.shared.updateTypingStatus(friend_id: self.userFriend?.friend_id ?? 0, is_typing: false)
        super.viewWillDisappear(animated)
    }
    
 
    
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        IQKeyboardManager.shared.enable = false
        setupMessageView()
        let infoButton = UIBarButtonItem(image: R.image.ic_info_menu(), style: .plain, target: self, action: #selector(infoButtonPressed))
        infoButton.tintColor = UIColor.appYellowColor
        let backButton = UIBarButtonItem(image: R.image.ic_back(), style: .plain, target: self, action: #selector(onBackPressed))
        backButton.tintColor = UIColor.appYellowColor
        navigationItem.rightBarButtonItem?.tintColor = UIColor.appYellowColor
        navigationItem.leftBarButtonItem?.tintColor = UIColor.appYellowColor
        
        
        let showMoreButton = UIBarButtonItem(image: R.image.show_more(), style: .plain, target: self, action: #selector(showMorePressed))
        showMoreButton.tintColor = UIColor.appYellowColor
        
        let userProfileView = UIBarButtonItem(customView: headerView)
        navigationItem.leftBarButtonItems = [backButton, userProfileView]
        navigationItem.rightBarButtonItems = [showMoreButton/*infoButton*/]
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        guard let friend = userFriend else {return}
        self.getCurrentUserChatWith(friendID: friend.friend_id, pageNumber: currentPage, isFetchingMore: false)
        
        if friend.is_online {
            headerView.subTitleLAbel.text = AppStrings.getOnlinString()
            headerView.subTitleLAbel.textColor = UIColor.appGreenColor
            headerView.onlineImageView.tintColor = UIColor.appGreenColor
            
        } else {
            headerView.subTitleLAbel.text = AppStrings.getOfflineString()
            headerView.subTitleLAbel.textColor = UIColor.lightGray
            headerView.onlineImageView.tintColor = UIColor.lightGray
        }
        
        
        headerView.titleLabel.text = friend.full_name
        headerView.namePrefixLabel.text = headerView.titleLabel.text?.getPrefix
        
        headerView.userImageView.kf.setImage(with: URL(string: friend.profile_image)) { (result) in
            switch result {
            case .success(_ ):
                
                self.headerView.namePrefixLabel.isHidden = true
                self.headerView.namePrefixLabel.text = self.headerView.titleLabel.text?.getPrefix
                self.headerView.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
            case .failure(_ ):
                self.headerView.namePrefixLabel.isHidden = false
                self.headerView.userImageView.image = nil
                self.headerView.namePrefixLabel.text = self.headerView.titleLabel.text?.getPrefix
                
            }
        }
        currentUser = Sender(senderId: "\(UserManager.shared.user_id)", displayName: UserManager.shared.first_name)
        otherUser = Sender(senderId: "\(friend.friend_id)", displayName: friend.full_name)
        
        
        headerView.subscribedImageView.isHidden = !isCurrentUserSubcribed
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFriendsOnlineStatus(_:)), name: .getOnlineLatestUsers, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addLatestMessageByOtherUser(_:)), name: .getInboxLatestData, object: nil)
    }
    
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            if self.lastPage > self.currentPage {
                self.currentPage = self.currentPage + 1
                self.getCurrentUserChatWith(friendID: self.userFriend?.friend_id ?? 0, pageNumber: self.currentPage, isFetchingMore: true)
            }
        }
    }
    
    @objc func addLatestMessageByOtherUser(_ notification: NSNotification) {
        guard let data = notification.object as? [String: Any],
              let messageDic = data["latestMessage"] as? [String: Any],
              let msgModel: InboxMessageModel = InboxMessageModel(JSON: messageDic)
        else {return}
        
        if msgModel.user_id != UserManager.shared.user_id {
            
            // Other User Message
            
            if msgModel.attachment != "" {
                // Media Message
                
                let newMessage = Message(sender: self.otherUser, messageId: "\(msgModel.message_id)", sentDate: msgModel.utc_sent_at.getDateObjectFromString(), kind: .photo(Media(url: URL(string: msgModel.attachment), image: UIImage(named: "greyBox"), placeholderImage: UIImage(named: "greyBox")!, size: CGSize(width: 300, height: 200))), isRead: msgModel.is_read, isSent: true)
                
                if !self.messages.contains(where: { msg in
                    msg.messageId == newMessage.messageId
                }) {
                    self.insertMessage(newMessage)
                }
                
                
                
            } else {
                // Text Message
                
                let newMessage = Message(sender: self.otherUser, messageId: "\(msgModel.message_id)", sentDate: msgModel.utc_sent_at.getDateObjectFromString(), kind: .text(msgModel.message), isRead: msgModel.is_read, isSent: true)
                
                if !self.messages.contains(where: { msg in
                    msg.messageId == newMessage.messageId
                }) {
                    self.insertMessage(newMessage)
                }
            }
        }
        
        
        
    }
    
    @objc func updateFriendsOnlineStatus(_ notification: NSNotification) {
        guard let objects = notification.object as? [Int] else {return}
        
        guard let friend = self.userFriend else {return}
        
        if objects.contains(friend.friend_id) {
            headerView.subTitleLAbel.text = AppStrings.getOnlinString()
            headerView.subTitleLAbel.textColor = UIColor.appGreenColor
            headerView.onlineImageView.tintColor = UIColor.appGreenColor
            
        } else {
            headerView.subTitleLAbel.text = AppStrings.getOfflineString()
            headerView.subTitleLAbel.textColor = UIColor.lightGray
            headerView.onlineImageView.tintColor = UIColor.lightGray
        }
    }
    
    @objc func setText() {
        // self.setTypingIndicatorViewHidden(false, animated: true)
    }
    
    func showMessageLimitExceedAlert() {
        let alertController = UIAlertController(title: AppStrings.getAlertString(), message: AppStrings.messageLimitExceed(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getBuyMessageString(), style: .default, handler: { (_ ) in
            // Move to Buy Package
            self.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: .redirectToShop, object: ["shopIndex":2])
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Dismiss
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        /* alertController.addAction(UIAlertAction(title: AppStrings.getBlockString(), style: .default, handler: { (_ ) in
            // Perform Block Action
            
           /* self.showSpinner(onView: self.view)
            FriendManager.acceptRejectFriendRequest(requestStatus: .blocked, requestID: "\(self.userFreind.friend_request_id)") { (status, errors) in
                self.removeSpinner()
                if errors == nil {
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: .refreshData, object: nil)
                    }
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            } */
            
        })) */
        alertController.addAction(UIAlertAction(title: AppStrings.getDeleteConversation(), style: .default, handler: { (_ ) in
            // Delete Conversation
            self.showSpinner(onView: self.view)
            guard let friend = self.userFriend else {return}
            ChatManager.deleteChat(friend_id: friend.friend_id) { baseResponse, errors in
                self.removeSpinner()
                if errors == nil {
                    self.navigationController?.popViewControllerWithHandler(completion: {
                        NotificationCenter.default.post(name: .reloadInbox, object: nil)
                    })
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
            
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Cancel
        }))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.messagesCollectionView
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self,
              selector: #selector(applicationWillTerminate(notification:)),
              name: UIApplication.willTerminateNotification,
              object: nil)
    }
    
    @objc func applicationWillTerminate(notification: Notification) {
        SocketHelper.shared.updateTypingStatus(friend_id: self.userFriend?.friend_id ?? 0, is_typing: false)
    }
    
    // MARK:- ACTIONS -
    
    @objc func infoButtonPressed() {
        print("Info Pressed")
    }
    @objc func showMorePressed() {
        showActionSheet()
    }
    @objc func cameraBtnTapped() {
        showPhotoPicker()
    }
    @objc func onBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}




