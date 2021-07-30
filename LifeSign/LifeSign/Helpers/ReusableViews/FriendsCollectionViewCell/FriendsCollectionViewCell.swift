//
//  FriendsCollectionViewCell.swift
//  LifeSign
//
//  Created by Haider Ali on 05/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import PopBounceButton
import MaterialComponents
import ImageViewer_swift
import SkeletonView

protocol FriendCollectionViewDelegate: AnyObject {
    func shouldReloadWith(isCurrentUserWon: Bool)
    func autoPlayMyTurn(play: Bool, progressGame: UserGameProgress, userFriend: Items)
}


class FriendsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var redDot: UIView!
    @IBOutlet weak var timeZoneTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var cardView: MDCCard!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.height * 0.5
            userImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.font = Constants.labelFontBold
            userNameLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var userTimeZoneLabel: UILabel! {
        didSet {
            userTimeZoneLabel.font = Constants.labelFontBold
            userTimeZoneLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgeViewHeigt: NSLayoutConstraint!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var imgBadgeWon: UIImageView! {
        didSet {
            imgBadgeWon.image = UIImage(named: "medal")
        }
    }
    @IBOutlet weak var leadingButton: DesignableButton! {
        didSet {
            leadingButton.titleLabel?.font = Constants.labelFont
            leadingButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var trailingButton: DesignableButton! {
        didSet {
            trailingButton.titleLabel?.font = Constants.labelFont
        }
    }
    
    @IBOutlet weak var buttonTopSpace: NSLayoutConstraint!
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    weak var delegate: FriendCollectionViewDelegate?
    
    var isFromHomeScreen: Bool = false
    var isGameOver: Bool = false
    
    var countDownTimer: Timer?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func emptyCell() {
        self.userImageView.image = nil
        self.userNameLabel.text = nil
        self.userTimeZoneLabel.text = nil
        self.leadingButton.setTitle(nil, for: .normal)
        self.trailingButton.setTitle(nil, for: .normal)
    }
    
    func showAnimation() {
        userImageView.showSkeleton()
        userNameLabel.showSkeleton()
        cardView.backgroundColor = .appBoxColor
        userTimeZoneLabel.showSkeleton()
        leadingButton.showSkeleton()
        namePrefixLabel.text = ""
        trailingButton.isHidden = true
    }
    
    func hideAnimation() {
        userImageView.hideSkeleton()
        userNameLabel.hideSkeleton()
        userTimeZoneLabel.hideSkeleton()
        leadingButton.hideSkeleton()
        trailingButton.isHidden = false
    }
    
    
    func configureGameAddCell() {
        self.userNameLabel.isHidden = true
        self.userTimeZoneLabel.text = AppStrings.playWitFriends()
        self.leadingButton.isHidden = true
        self.userImageView.image = R.image.ic_addPokeGame()
        self.buttonContainerView.isHidden = false
        namePrefixLabel.text = ""
        userImageView.isUserInteractionEnabled = false
        imgBadgeWon.isHidden = true
        trailingButton.backgroundColor = .appYellowColor
        trailingButton.setTitleColor(.appBackgroundColor, for: .normal)
        cardView.backgroundColor = R.color.appBoxesColor()
        userTimeZoneLabel.textColor = .white
        userNameLabel.textColor = .white
        self.trailingButton.setTitle(AppStrings.getAddNowString(), for: .normal)
    }
    
    
    fileprivate func handleTurnPlay(_ prgressGame: UserGameProgress, _ nowTime: Date, _ nextTime: Date, _ userFriend: Items)  {
        if prgressGame.click_by_user_id == 0 {
            if prgressGame.game_start_by_user_id == UserManager.shared.user_id {
                // Opponent Turn
                cardView.backgroundColor = R.color.appDarkGreenColor()
                leadingButton.isHidden = false
                leadingButton.setTitle(AppStrings.getOpponentTurn(), for: .normal)
                leadingButton.setTitleColor(.white, for: .normal)
                leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.2)
                isGameOver = false
                userNameLabel.textColor = .white
                userTimeZoneLabel.textColor = .white
            } else {
                // My Turn
                cardView.backgroundColor = R.color.appRedColor()
                leadingButton.isHidden = false
                leadingButton.setTitle(AppStrings.getYourTurn(), for: .normal)
                leadingButton.setTitleColor(.white, for: .normal)
                leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.5)
                isGameOver = false
                userNameLabel.textColor = .white
                userTimeZoneLabel.textColor = .white
                
                self.delegate?.autoPlayMyTurn(play: UserManager.shared.enable_autoclicks, progressGame: prgressGame, userFriend: userFriend)
                
            }
        } else if prgressGame.click_by_user_id == UserManager.shared.user_id {
            // Opponent Turn
            cardView.backgroundColor = R.color.appDarkGreenColor()
            leadingButton.isHidden = false
            leadingButton.setTitle(AppStrings.getOpponentTurn(), for: .normal)
            leadingButton.setTitleColor(.white, for: .normal)
            leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.2)
            isGameOver = false
            userNameLabel.textColor = .white
            userTimeZoneLabel.textColor = .white
            
        } else {
            // My Turn
            cardView.backgroundColor = R.color.appRedColor()
            leadingButton.isHidden = false
            leadingButton.setTitle(AppStrings.getYourTurn(), for: .normal)
            leadingButton.setTitleColor(.white, for: .normal)
            leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.5)
            isGameOver = false
            userNameLabel.textColor = .white
            userTimeZoneLabel.textColor = .white
            self.delegate?.autoPlayMyTurn(play: UserManager.shared.enable_autoclicks, progressGame: prgressGame, userFriend: userFriend)
        }
        
        handleWinOrLossStatus(prgressGame, nowTime, nextTime, userFriend)
        
    }
    
    fileprivate func configurePlayAgain(_ userFriend: Items, buttonTitle: String, labelTitle: String, cardColor: UIColor = .appBoxColor) {
        // Other user won the Game
        cardView.backgroundColor = cardColor
        self.leadingButton.isHidden = false
        self.trailingButton.isHidden = false
        self.leadingButton.setTitle(buttonTitle, for: .normal)
        userTimeZoneLabel.text = labelTitle
        
        userNameLabel.textColor = .white
        userTimeZoneLabel.textColor = .white
        leadingButton.setTitleColor(.white, for: .normal)
        trailingButton.setTitleColor(.appBackgroundColor, for: .normal)
        self.leadingButton.backgroundColor = R.color.appDarkGreenColor()
        trailingButton.backgroundColor = R.color.appYellowColor()
        trailingButton.isHidden = false
        
        trailingButton.setTitle(AppStrings.getRemoveString(), for: .normal)
        
    }
    
    fileprivate func handleWinOrLossStatus(_ prgressGame: UserGameProgress, _ nowTime: Date, _ nextTime: Date, _ userFriend: Items) {
        
        if isGameOver {return}
        
        if prgressGame.click_by_user_id == UserManager.shared.user_id {
            // Opponent Turn
            
            if nowTime > nextTime {
                
                // I WON THE GAME
                
                self.countDownTimer?.invalidate()
                self.countDownTimer = nil
                
                isGameOver = true
                configurePlayAgain(userFriend, buttonTitle: AppStrings.playAgainString(), labelTitle: AppStrings.youWonString(), cardColor: .appBoxColor)
                imgBadgeWon.isHidden = false
                GameManager.endGameAndDecideWinner(game_id: prgressGame.game_id, winner_user_id: prgressGame.click_by_user_id) { status, errors in
                    
                    self.delegate?.shouldReloadWith(isCurrentUserWon: true)
                    
                    // NotificationCenter.default.post(name: .reloadGameScreen, object: nil)
                }
                
            }
            
        } else {
            // My Turn
            if nowTime > nextTime {
                // I LOSS THE GAME
                
                self.countDownTimer?.invalidate()
                self.countDownTimer = nil
                
                isGameOver = true
                imgBadgeWon.isHidden = true
                self.delegate?.shouldReloadWith(isCurrentUserWon: false)
                // NotificationCenter.default.post(name: .reloadGameScreen, object: nil)
                configurePlayAgain(userFriend, buttonTitle: AppStrings.playAgainString(), labelTitle: AppStrings.youLossString(), cardColor: .appBoxColor)
            }
            
        }
    }
    
    func configureGameFriendCell(withName: String, userImage: String?, userFriend: Items? = nil) {
        
        hideAnimation()
        self.userNameLabel.isHidden = false
        userNameLabel.text = withName
        
        if cardView.backgroundColor == R.color.appGreenColor() {
            userNameLabel.textColor = R.color.appBoxesColor()
            userTimeZoneLabel.textColor = R.color.appBoxesColor()
        }
        
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = UIColor.appYellowColor
        
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
        
        
        
        if userImage != "" {
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                switch result {
                case .success(_ ):
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = withName.getPrefix
                    self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = withName.getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.userImageView.image = nil
            self.namePrefixLabel.text = withName.getPrefix
        }
        buttonContainerView.isHidden = false
        trailingButton.isHidden = true
        guard let friend = userFriend else {return}
        userTimeZoneLabel.isHidden = false
        userTimeZoneLabel.numberOfLines = 2
        userTimeZoneLabel.text = friend.remaining_time
        
        switch friend.game_request {
        case .waiting:
            cardView.backgroundColor = R.color.appOrangeColor()
            userTimeZoneLabel.text = AppStrings.wantsToAddYouGameFriend()
            
            leadingButton.setTitle(AppStrings.getCancelRequestString(), for: .normal)
            leadingButton.isHidden = false
            userNameLabel.textColor = .white
            userTimeZoneLabel.textColor = .white
            
            leadingButton.setTitleColor(.white, for: .normal)
            leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.2)
        case .pending:
            self.configureLeadingTrailingButtonCell(leadingButtonName: AppStrings.getAcceptString(), trailingButtonName: AppStrings.getRejectString(), subtitle: AppStrings.gameFriendInviation())
        case .accepted:
    
            guard let prgressGame = userFriend?.progress_games else {return}
            
            // SHOW TIMER
            if prgressGame.utc_time != "" {
                
                self.countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_ ) in
                    var nextTime = Date()
                    nextTime = prgressGame.utc_time.getDateObjectFromString()
                    let nowTime = Date()
                    if let timer = Calendar.current.date(byAdding: .minute, value: 0, to: nextTime) {
                        let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                        let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: timer)
                        let timerComponents = self.componentsFormatter.string(from: components)
                        
                        self.userTimeZoneLabel.text = (timerComponents ?? "")
                    }
                    self.imgBadgeWon.isHidden = true
                    
                    self.handleTurnPlay(prgressGame, nowTime, nextTime, friend)
                }
            }
            if (friend.game_start_status == .free) && (friend.game_request == .accepted) {
                // Send Invitation State
                cardView.backgroundColor = .appBoxColor
                userNameLabel.textColor = .white
                userTimeZoneLabel.textColor = .white
                userTimeZoneLabel.text = AppStrings.playGameString()
                leadingButton.backgroundColor = .appGreenColor
                leadingButton.setTitleColor(.appBackgroundColor, for: .normal)
                leadingButton.setTitle(AppStrings.sendInvitation(), for: .normal)
                
                if friend.game_winner == 2 {
                    // SEND INVITATION STATE
                    leadingButton.isHidden = false
                    imgBadgeWon.isHidden = true
                } else if friend.game_winner == 1 {
                    // CURRENT USER WON THE GAME
                    imgBadgeWon.isHidden = false
                    configurePlayAgain(friend, buttonTitle: AppStrings.playAgainString(), labelTitle: AppStrings.youWonString(), cardColor: .appBoxColor)
                } else if friend.game_winner == 0 {
                    // CURRENT USER LOSS THE GAME
                    imgBadgeWon.isHidden = true
                    configurePlayAgain(friend, buttonTitle: AppStrings.playAgainString(), labelTitle: AppStrings.youLossString(), cardColor: .appBoxColor)
                }
                
            }
            if (friend.game_request == .accepted) && (friend.game_start_status == .pending) {
                // Show Accept / Reject Game Play Invitation
                configureLeadingTrailingButtonCell(leadingButtonName: AppStrings.getAcceptString(), trailingButtonName: AppStrings.getRejectString(), subtitle: AppStrings.wantsToPlayGame())
            }
            
            if (friend.game_request == .accepted) && (friend.game_start_status == .waiting) {
                // Game Request Sent - Now I am Waiting
                cardView.backgroundColor = R.color.appOrangeColor()
                userTimeZoneLabel.text = AppStrings.invitationSent()
                
                leadingButton.setTitle(AppStrings.getCancelRequestString(), for: .normal)
                leadingButton.isHidden = false
                userNameLabel.textColor = .white
                userTimeZoneLabel.textColor = .white
                
                leadingButton.setTitleColor(.white, for: .normal)
                leadingButton.backgroundColor = R.color.appLigtGray()?.withAlphaComponent(0.2)
            }
            
            
            
            
        default:
            print("Default")
        }
    }
    
    func configureLeadingTrailingButtonCell(leadingButtonName: String, trailingButtonName: String, subtitle: String) {
        
        cardView.backgroundColor = UIColor.appYellowColor
        userNameLabel.textColor = .appBackgroundColor
        
        leadingButton.backgroundColor = R.color.appDarkGreenColor()
        trailingButton.backgroundColor = .systemRed
        
        leadingButton.setTitleColor(.white, for: .normal)
        trailingButton.setTitleColor(.white, for: .normal)
        
        userTimeZoneLabel.text = subtitle
        userTimeZoneLabel.textColor = .appBackgroundColor
        userNameLabel.textColor = .appBackgroundColor
        
        leadingButton.isHidden = false
        trailingButton.isHidden = false
        
        leadingButton.setTitle(leadingButtonName, for: .normal)
        trailingButton.setTitle(trailingButtonName, for: .normal)
    }
    
    
    func configureCell(withName: String, userImage: String?, userFriend: Items? = nil) {
        userNameLabel.text = withName
        cardView.backgroundColor = .appBoxColor
        if cardView.backgroundColor == R.color.appGreenColor() {
            userNameLabel.textColor = R.color.appBoxesColor()
            userTimeZoneLabel.textColor = R.color.appBoxesColor()
        }
        
        userNameLabel.textColor = .white
        userTimeZoneLabel.textColor = .white
        
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = UIColor.appYellowColor
        
        if userImage != "" {
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                switch result {
                case .success(_ ):
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = withName.getPrefix
                    self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = withName.getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.userImageView.image = nil
            self.namePrefixLabel.text = withName.getPrefix
        }
        
        guard let friend = userFriend else {return}
        userTimeZoneLabel.text = friend.timezone
        handleUserRequestStausForDailySign(userFriend: friend)
        
    }
    
    func configureCellForOKSign(withName: String, userImage: String?, state: OKSignStats) {
        userNameLabel.text = withName
        
        if cardView.backgroundColor == R.color.appGreenColor() {
            userNameLabel.textColor = R.color.appBoxesColor()
            userTimeZoneLabel.textColor = R.color.appBoxesColor()
        }
        
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = R.color.appLigtGray()
        buttonContainerView.isHidden = false
        leadingButton.isHidden =  true
        
        redDot.isHidden = true
        
        switch state {
        case .checkFriend:
            userImageView.backgroundColor = UIColor.appYellowColor
            userNameLabel.textColor = R.color.appLightFontColor()
            userTimeZoneLabel.textColor = R.color.appLightFontColor()
            trailingButton.setTitle(AppStrings.getOkSignRemind(), for: .normal)
            cardView.backgroundColor = R.color.appRedColor()
            trailingButton.backgroundColor = UIColor.appYellowColor
        case .tellFriend:
            userImageView.backgroundColor = UIColor.appYellowColor
            userNameLabel.textColor = R.color.appBoxesColor()
            userTimeZoneLabel.textColor = R.color.appBoxesColor()
            trailingButton.setTitle(AppStrings.getIamOkString(), for: .normal)
            cardView.backgroundColor = R.color.appGreenColor()
            trailingButton.backgroundColor = UIColor.appYellowColor
        case .acceptReject:
            leadingButton.isHidden =  false
            leadingButton.backgroundColor = UIColor.appYellowColor
            // leadingButton.setTitleColor(R.color.appBoxesColor(), for: .normal)
            trailingButton.backgroundColor = R.color.appRedColor()
            leadingButton.setTitle(AppStrings.getAcceptString(), for: .normal)
            trailingButton.setTitle(AppStrings.getRejectString(), for: .normal)
        case .gotIt:
            userImageView.backgroundColor = UIColor.appYellowColor
            userNameLabel.textColor = R.color.appLightFontColor()
            userTimeZoneLabel.textColor = R.color.appLightFontColor()
            redDot.isHidden = false
            trailingButton.setTitle(AppStrings.sosGotIT(), for: .normal)
            cardView.backgroundColor = R.color.appRedColor()
            trailingButton.backgroundColor = UIColor.appYellowColor
        case .reminderReceived:
            userImageView.backgroundColor = R.color.appLigtGray()
            userNameLabel.textColor = R.color.appBoxesColor()
            userTimeZoneLabel.textColor = R.color.appBoxesColor()
            trailingButton.setTitle(AppStrings.getIamOkString(), for: .normal)
            cardView.backgroundColor = R.color.appGreenColor()
            trailingButton.backgroundColor = R.color.appLigtGray()
        }
        
        if userImage != "" {
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                switch result {
                case .success(_ ):
                    // print(data)
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = withName.getPrefix
                    self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    // print(err.localizedDescription)
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = withName.getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.userImageView.image = nil
            self.namePrefixLabel.text = withName.getPrefix
        }
        
    }
    
    func adjustImageHeigt(heigth: CGFloat, width: CGFloat) {
        containerHeight.constant = heigth
        self.imgeViewHeigt.constant = heigth
        self.namePrefixLabel.font = Constants.paragraphFont
        self.imgViewWidth.constant = width
        userImageView.layer.cornerRadius = heigth / 2
    }
    
    
    func handleUserRequestStausForDailySign(userFriend: Items) {
        switch userFriend.sign_request {
        case .waiting:
            userNameLabel.textColor = UIColor.white
            userTimeZoneLabel.textColor = UIColor.white
            buttonContainerView.isHidden = false
            leadingButton.isHidden = true
            userTimeZoneLabel.font = Constants.labelFont
            trailingButton.setTitle(AppStrings.getWaitingString(), for: .normal)
            cardView.backgroundColor = UIColor.appBoxColor
            mainButton.isEnabled = false
        case .pending:
            userNameLabel.textColor = UIColor.white
            userTimeZoneLabel.textColor = UIColor.white
            userTimeZoneLabel.font = Constants.labelFont
            buttonContainerView.isHidden = false
            leadingButton.isHidden = false
            trailingButton.isHidden = false
            leadingButton.setTitle(AppStrings.getAcceptString(), for: .normal)
            trailingButton.setTitle(AppStrings.getRejectString(), for: .normal)
            mainButton.isEnabled = false
            cardView.backgroundColor = UIColor.appBoxColor
            trailingButton.setTitle(AppStrings.getRejectString(), for: .normal)
        default:
            // Default Case is The User DailySign Friend
            handleUserDailySignFriend(userFriend: userFriend)
        }
    }
    
    
    func handleUserDailySignFriend(userFriend: Items) {
        
        // Default Color is Green
        
        cardView.backgroundColor = UIColor.appGreenColor
        userNameLabel.textColor = UIColor.appBoxColor
        userTimeZoneLabel.textColor = UIColor.appBoxColor
        mainButton.isEnabled = false
        
        userTimeZoneLabel.font = Constants.headerTitleFont
        
        if isFromHomeScreen {
            self.timeZoneTopConstraints.constant = 5
        }
        
        var nextTime = Date()
        nextTime = userFriend.next_ping_datetime.getDateObjectFromString()
        let nowTime = Date()
        
        // Show Timer
        
        if userFriend.next_ping_datetime != "" {
            if let timer = Calendar.current.date(byAdding: .minute, value: 0, to: nextTime) {
                let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: timer)
                let timerComponents = self.componentsFormatter.string(from: components)
                userTimeZoneLabel.text = (timerComponents ?? "") + " " + (userFriend.initiator == 1 ? "" : "")
            }
        }
        
        if userFriend.initiator == 1 // Current User is The DailySign Sender
        {
            // print("Send LS TO: \(userFriend.full_name)")
            
            if nowTime >= nextTime {
                // Turn State To Orange
                cardView.backgroundColor = R.color.appOrangeColor()
                userTimeZoneLabel.text = AppStrings.getAwaitingDS()
            }
        }
        else // Current User is The DailSign Receiver
        {
            // Enable Big Main Button Before 30 Minute from the Next Ping Time
            
            if let time30MinBefore = Calendar.current.date(byAdding: .minute, value: Constants.thirthyMinBefore, to: nextTime) {
                
                if nowTime >= time30MinBefore {
                    mainButton.isEnabled = true
                    userTimeZoneLabel.font = Constants.labelFont
                    cardView.backgroundColor = UIColor.appYellowColor
                    userTimeZoneLabel.text = "\(AppStrings.getSendDS()) \n" + (userTimeZoneLabel.text ?? "")
                    userTimeZoneLabel.zoomInZoomOut()
                }
            }
            
            if nowTime >= nextTime {
                // Turn State To RED
                cardView.backgroundColor = R.color.appRedColor()
                
                if let oneMoreHour = Calendar.current.date(byAdding: .hour, value: 1, to: nextTime) {
                    let desiredComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                    let components = Calendar.current.dateComponents(desiredComponents, from: nowTime, to: oneMoreHour)
                    let timerComponents = self.componentsFormatter.string(from: components)
                    userNameLabel.textColor = .white
                    userTimeZoneLabel.textColor = .white
                    if let timeLeft = timerComponents {
                        userTimeZoneLabel.text = AppStrings.getSendDS() + "\n" + timeLeft
                        userTimeZoneLabel.zoomInZoomOut()
                    }
                    if oneMoreHour < nowTime {
                        userTimeZoneLabel.text = AppStrings.getSendDS()
                        print("** Time Over **")
                    }
                    
                }
                
            }
        }
        
    }
}
