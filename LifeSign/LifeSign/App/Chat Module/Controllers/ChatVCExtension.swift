//
//  ChatVCExtension.swift
//  LifeSign
//
//  Created by Haider Ali on 25/05/2021.
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


extension ChatVC {
    
    // GET USER CHAT
    
    func getCurrentUserChatWith(friendID: Int, pageNumber: Int, isFetchingMore: Bool) {
       
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.showSpinner(onView: self.view)
        }
    
        ChatManager.getUserChatWitFriend(friend_ID: friendID, pageNumber: pageNumber) { chatResponse, errors in
            self.removeSpinner()
            if errors == nil {
                guard let response = chatResponse else {return}
                if response.is_promotion {
                    // Disable Send Message Functionality
                    
                    self.messageInputBar.isHidden = true
                    
                } else {
                    self.messageInputBar.isHidden = false
                }
                var respMessages: [Message] = [Message]()
                self.isCurrentUserSubcribed = response.is_buy_package
                self.headerView.subscribedImageView.isHidden = !self.isCurrentUserSubcribed
                if let allMessages = response.chatBaseData?.chatMessages {
                    self.messagesFromServer = allMessages
                    for message  in allMessages {
                        
                        if message.user_id != UserManager.shared.user_id {
                            
                            // Other User Message
                            
                            if message.attachment != "" {
                                // Media Message
                                
                                let newMessage = Message(sender: self.otherUser, messageId: "\(message.message_id)", sentDate: message.utc_sent_at.getDateObjectFromString(), kind: .photo(Media(url: URL(string: message.attachment), image: UIImage(named: "greyBox"), placeholderImage: UIImage(named: "greyBox")!, size: CGSize(width: 300, height: 200))), isRead: message.is_read, isSent: true)
                                
                                respMessages.append(newMessage)
                                
                            } else {
                                // Text Message
                                
                                let newMessage = Message(sender: self.otherUser, messageId: "\(message.message_id)", sentDate: message.utc_sent_at.getDateObjectFromString(), kind: .text(message.message), isRead: message.is_read, isSent: true)
                                respMessages.append(newMessage)
                                
                            }
                            
                        } else {
                            
                            // My Message
                            if message.attachment != "" {
                                
                                let newMessage = Message(sender: self.currentUser, messageId: "\(message.message_id)", sentDate: message.utc_sent_at.getDateObjectFromString(), kind: .photo(Media(url: URL(string: message.attachment), image: UIImage(named: "greyBox"), placeholderImage: UIImage(named: "greyBox")!, size: CGSize(width: 300, height: 200))), isRead: message.is_read, isSent: true)
                                respMessages.append(newMessage)
                                
                                
                            } else {
                                let newMessage = Message(sender: self.currentUser, messageId: "\(message.message_id)", sentDate: message.utc_sent_at.getDateObjectFromString(), kind: .text(message.message), isRead: message.is_read, isSent: true)
                               
                                respMessages.append(newMessage)
                            }
                        }
                        
                    }
                    
                    guard let links = chatResponse?.chatBaseData?.links else {return}
                    self.lastPage = links.last_page
                    
                    if isFetchingMore {
                        self.messages.insert(contentsOf: respMessages, at: 0)
                        self.messagesCollectionView.reloadDataAndKeepOffset()
                        self.refreshControl.endRefreshing()
                    } else {
                        self.messages = respMessages
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToLastItem()
                    }
                }
                
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
}

///
// MARK:- Image Picker -
///

extension ChatVC {
    func showPhotoPicker () {
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                if let imageData = photo.image.jpegData(compressionQuality: 0.5), let friend = self.userFriend {
                    self.isAllMessagesRead = false
                    ChatManager.sendMessage(image: imageData, params: ["message":"Image", "friend_id":"\(friend.friend_id)"]) { status, errors in
                        if errors == nil {
                            let mediaMessage = Message(sender: self.currentUser, messageId: "21", sentDate: Date(), kind: .photo(Media(url: nil, image: photo.originalImage, placeholderImage: Constants.getCurrentUserImage(), size: CGSize(width: 300, height: 200))), isRead: false, isSent: true)
                            
                            self.insertMessage(mediaMessage)
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                    }
                }
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}

///
// MARK:- INPUT ACCECCORY VIEW -
///

extension ChatVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        // Append a new Message
        
        guard let friend = userFriend else {return}
        inputBar.inputTextView.text = ""
        self.isAllMessagesRead = false
        let message = Message(sender: self.currentUser, messageId: "myUnSentMessage", sentDate: Date(), kind: .text(text), isRead: false, isSent: false)
        self.insertMessage(message)
        
        ChatManager.sendMessage(image: nil, params: ["message":text, "friend_id":"\(friend.friend_id)"]) { status, errors in
            // removeSpinner()
            if errors == nil {
                
                
                if self.isCurrentUserSubcribed {
                    // Simply Send Message
                } else {
                    // Subscribe This User Against Me
                    guard let friend  = self.userFriend else {return}
                    ChatManager.buyMessagePkgAgainst(friend_id: friend.friend_id) { status, errors in
                        if errors == nil {
                            self.getCurrentUserChatWith(friendID: friend.friend_id, pageNumber: self.currentPage, isFetchingMore: false)
                        } else {
                            ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                        }
                    }
                    
                }
                print("Message Sent Succesfully")
            } else {
                self.messages.removeLast()
                self.messagesCollectionView.reloadDataAndKeepOffset()
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
        
        SocketHelper.shared.updateTypingStatus(friend_id: friend.friend_id, is_typing: false)
        
    }
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        self.charactersCountLabel.text = "\(text.count)/140"
        
        if (text.count) > Constants.MESSAGE_CHARACTER_LIMIT {
            
            if let userAvailableMessageContacts = UserManager.shared.userResources?.message_contact {
                if userAvailableMessageContacts > 0 {
                    // You can Send Message Over 140 Plus
                    self.charactersCountLabel.isHidden = true
                } else {
                    self.charactersCountLabel.isHidden = false
                    self.showMessageLimitExceedAlert()
                }
            }
        }
        
        if inputBar.inputTextView.text.count > Constants.MESSAGE_CHARACTER_LIMIT {
            inputBar.inputTextView.text.removeLast()
        }
        
        updateTypingStatus(text: text)
    }
    
    func updateTypingStatus(text: String) {
        guard let friend  = self.userFriend else {return}
        SocketHelper.shared.updateTypingStatus(friend_id: friend.friend_id, is_typing: text.count > 0 ? true : false)
    }
}


extension ChatVC: MessageCellDelegate {
    
    func setupMessageView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.keyboardDismissMode = .onDrag
        let cameraButton = UIButton()
        cameraButton.addTarget(self, action: #selector(cameraBtnTapped), for: .touchUpInside)
        cameraButton.setImage(R.image.ic_camera(), for: .normal)
        cameraButton.tintColor = UIColor.appYellowColor
        messageInputBar.leftStackView.addArrangedSubview(cameraButton)
        messageInputBar.setLeftStackViewWidthConstant(to: 44, animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.sendButton.setTitle(nil, for: .normal)
        messageInputBar.sendButton.setImage(R.image.ic_send_message(), for: .normal)
        
        messageInputBar.inputTextView.placeholder = AppStrings.getWriteMsgHereString()
        messageInputBar.delegate = self
        messagesCollectionView.refreshControl = refreshControl
        messageInputBar.bottomStackView.addArrangedSubview(charactersCountLabel)
    }
}


///
// MARK:- MESSGAES DATASOURCE -
///

extension ChatVC: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        if indexPath.section != messages.count {
            return messages[indexPath.section]
        } else {
            return messages[indexPath.section - 1]
        }
    }
}


extension ChatVC: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return message.sender.senderId == currentUser.senderId ? .bubbleTail(.bottomRight, .pointedEdge) : .bubbleTail(.bottomLeft, .pointedEdge)
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == self.currentUser.senderId {
            
            avatarView.image = Constants.getCurrentUserImage()
            
        } else {
            avatarView.kf.indicatorType = .activity
            avatarView.image = Constants.getFriendImage(withUrl: self.userFriend?.profile_image ?? "", name: self.userFriend?.full_name ?? "")
        }
        
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        switch message.kind {
        case .photo(let photoItem):
            
            /// if we don't have a url, that means it's simply a pending message
            guard let url = photoItem.url else {
                imageView.kf.indicator?.startAnimatingView()
                return
            }
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url)
            imageView.setupImageViewer()
        default:
            break
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let message = messages[indexPath.section]
        return message.sender.senderId == currentUser.senderId ? UIColor.appBoxColor : UIColor.appYellowColor
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let message = messages[indexPath.section]
        return message.sender.senderId == currentUser.senderId ? .white : UIColor.appBoxColor
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: Constants.labelFont, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        guard let msg = message as? Message else {
            return nil
        }
        
        if msg.sender.senderId != self.currentUser.senderId {
            return nil
        }
        
        let str = (msg.isRead || self.isAllMessagesRead) ? AppStrings.getSeenString() : ""
        
        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.font: Constants.fontSize12, NSAttributedString.Key.foregroundColor: (msg.isRead || self.isAllMessagesRead) ? UIColor.appGreenColor: .clear])
        
    }
    
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section == 0 {
            return 16
        }
        
        // get previous message
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate){
            return 0
        } else {
            return 16
        }
    }
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if message.sender.senderId != self.otherUser.senderId {
            // print("IndexPat: \(indexPath.row)")
            return isMessageSelected ? 20 : 20
        } else {
            return 0
        }
    }
    
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func insertMessage(_ message: Message) {
        self.messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            if self.messages.count >= 2 {
                messagesCollectionView.reloadSections([self.messages.count - 2])
            }
        }, completion: { [weak self] _ in
            self?.messagesCollectionView.scrollToLastItem(animated: true)
        })
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        self.isMessageSelected = !self.isMessageSelected
        
       // self.messagesCollectionView.reloadDataAndKeepOffset()
        
        print("SSSS")
    }
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message when audio cell receive tap gesture")
            return
        }
        switch message.kind {
        case .photo(let photoItem):
            
            print("URL: \(String(describing: photoItem.url ?? URL.init(string: "")))")
            
            if let photoUrl = photoItem.url {
                let images = [
                    LightboxImage(imageURL: photoUrl),
                ]

                // Create an instance of LightboxController.
                let controller = LightboxController(images: images)

                // Use dynamic background.
                controller.dynamicBackground = true

                // Present your controller.
                present(controller, animated: true, completion: nil)
            }
            
        default:
            break
        }
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
          switch detector {
          case .hashtag, .mention: return [.foregroundColor: UIColor.appYellowColor]
          default: return MessageLabel.defaultAttributes
          }
      }
      

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: Constants.labelFont])
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: Constants.fontSize12, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
}
