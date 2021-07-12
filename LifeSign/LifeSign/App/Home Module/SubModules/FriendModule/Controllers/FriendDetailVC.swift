//
//  FriendDetailVC.swift
//  LifeSign
//
//  Created by Haider Ali on 02/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import ImageViewer_swift
import DateTimePicker


class FriendDetailVC: LifeSignBaseVC , DateTimePickerDelegate{

    // MARK:- OUTLETS -
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTimeZondeLabel: UILabel!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var sosLabel: UILabel!
    @IBOutlet weak var okSignLabel: UILabel!
    @IBOutlet weak var lifeSignLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var blockFriendLabel: UILabel!
    @IBOutlet weak var deleteFriendLabel: UILabel!
    
    @IBOutlet weak var sosButton: UIButton!
    @IBOutlet weak var okSignButton: UIButton!
    @IBOutlet weak var lifeSignButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var notificationButton: UISwitch!
    @IBOutlet weak var blockFriendButton: UIButton!
    @IBOutlet weak var deleteFriendButton: UIButton!
    
    var userFreind: Items!
    var openChatWitFriend: ((_ friend: Items?) -> Void)?
    var navigateToShop: ((_ friend: Items?) -> Void)?
    
    let timePicker = UIDatePicker()
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setText()
        observeLanguageChange()
        // Do any additional setup after loading the view.
    }
    

    @objc func setUpUI () {
        
        userNameLabel.font = Constants.headerTitleFont
        userTimeZondeLabel.font = Constants.labelFont
        sendMessageButton.titleLabel?.font = Constants.labelFont
        
        sosLabel.font = Constants.labelFont
        okSignLabel.font = Constants.labelFont
        lifeSignLabel.font = Constants.labelFont
        heartLabel.font = Constants.labelFont
        notificationLabel.font = Constants.labelFont
        blockFriendLabel.font = Constants.labelFont
        deleteFriendLabel.font = Constants.labelFont
        
        sosButton.titleLabel?.font = Constants.labelFont
        okSignButton.titleLabel?.font = Constants.labelFont
        lifeSignButton.titleLabel?.font = Constants.labelFont
        heartButton.titleLabel?.font = Constants.labelFont
        
        blockFriendButton.titleLabel?.font = Constants.labelFont
        deleteFriendButton.titleLabel?.font = Constants.labelFont
        
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        
        userImageView.backgroundColor = R.color.appYellowColor()
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: userFreind.profile_image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                self.namePrefixLabel.isHidden = true
                let fullName = self.userFreind.first_name + " " + self.userFreind.last_name
                self.namePrefixLabel.text = fullName.getPrefix
                
                self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                
            case .failure(_ ):
                // print(err.localizedDescription)
                self.namePrefixLabel.isHidden = false
                self.userImageView.image = nil
                let fullName = self.userFreind.first_name + " " + self.userFreind.last_name
                self.namePrefixLabel.text = fullName.getPrefix
            }
        }
        
    }
    
    @objc func setText() {
        
        userNameLabel.text = userFreind.first_name + " " + userFreind.last_name
        userTimeZondeLabel.text = userFreind.timezone
        sendMessageButton.setTitle(AppStrings.getSendMessageString(), for: .normal)
        
        sosLabel.text = AppStrings.getAddinSOSString()
        okSignLabel.text = AppStrings.getAddinOKSignString()
        lifeSignLabel.text = AppStrings.getAddinLifeSignString()
        heartLabel.text = AppStrings.getAddinHealthSignString()
        notificationLabel.text = AppStrings.getNotificationString()
        blockFriendLabel.text = AppStrings.getAddinBlockString()
        deleteFriendLabel.text = AppStrings.getDeleteString()
        
        sosButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        okSignButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        lifeSignButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        heartButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        
        blockFriendButton.setTitle(nil, for: .normal)
        deleteFriendButton.setTitle(nil, for: .normal)
        
        
        handleSOSStatus()
        handleOkSignStatus()
        handleDailySignRequest()
        
    }
    
    func handleSOSStatus() {
        
        switch userFreind.sos_friend_status {
        case .accepted:
            self.sosButton.isUserInteractionEnabled = false
            self.sosButton.setTitle(AppStrings.getAddedString(), for: .normal)
            self.sosButton.setTitleColor(R.color.appGreenColor(), for: .normal)
        case "":
            self.sosButton.isUserInteractionEnabled = true
            sosButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        case .pending:
            self.sosButton.isUserInteractionEnabled = false
            sosButton.setTitle(AppStrings.getWaitingString(), for: .normal)
            self.sosButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
        case .waiting:
            self.sosButton.isUserInteractionEnabled = false
            self.sosButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
            sosButton.setTitle(AppStrings.getFriendPendigString(), for: .normal)
        default:
            return
        }
    }
    
    func handleDailySignRequest() {
        
        switch userFreind.daily_sign_friend_status {
        case .accepted:
            self.lifeSignButton.isUserInteractionEnabled = false
            self.lifeSignButton.setTitle(AppStrings.getAddedString(), for: .normal)
            self.lifeSignButton.setTitleColor(R.color.appGreenColor(), for: .normal)
        case "":
            self.lifeSignButton.isUserInteractionEnabled = true
            lifeSignButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        case .pending:
            self.lifeSignButton.isUserInteractionEnabled = false
            lifeSignButton.setTitle(AppStrings.getWaitingString(), for: .normal)
            self.lifeSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
        case .waiting:
            self.lifeSignButton.isUserInteractionEnabled = false
            self.lifeSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
            lifeSignButton.setTitle(AppStrings.getFriendPendigString(), for: .normal)
        default:
            return
        }
    }
    
    func handleOkSignStatus() {
        switch userFreind.agreement_friend_status {
        case .accepted:
            if userFreind.agreement_dual == .single {
                
                if userFreind.agreement_status == .notAdded {
                    self.okSignButton.isUserInteractionEnabled = true
                    okSignButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
                    
                } else if userFreind.agreement_status == .added {
                    self.okSignButton.isUserInteractionEnabled = false
                    okSignButton.setTitle(AppStrings.getAddedString(), for: .normal)
                    self.okSignButton.setTitleColor(R.color.appGreenColor(), for: .normal)
                }
                   
            } else {
                if userFreind.agreement_status == .waiting {
                    self.okSignButton.isUserInteractionEnabled = false
                    okSignButton.setTitle(AppStrings.getFriendPendigString(), for: .normal)
                    self.okSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
                    
                } else {
                    self.okSignButton.isUserInteractionEnabled = false
                    self.okSignButton.setTitle(AppStrings.getAddedString(), for: .normal)
                    self.okSignButton.setTitleColor(R.color.appGreenColor(), for: .normal)
                }
            }
        case "":
            self.okSignButton.isUserInteractionEnabled = true
            okSignButton.setTitle(AppStrings.getNOTAddedString(), for: .normal)
        case .pending:
            
            if userFreind.agreement_status == .pending {
                self.okSignButton.isUserInteractionEnabled = false
                okSignButton.setTitle(AppStrings.getFriendPendigString(), for: .normal)
                self.okSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
            } else if userFreind.agreement_status == .waiting {
                self.okSignButton.isUserInteractionEnabled = false
                okSignButton.setTitle(AppStrings.getWaitingString(), for: .normal)
                self.okSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
            }
            
            
        case .waiting:
            self.okSignButton.isUserInteractionEnabled = false
            okSignButton.setTitle(AppStrings.getFriendPendigString(), for: .normal)
            self.okSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
        default:
            return
        }
    }
    
    func showLifeSignSenderAlert(withUserName: String, time: String) {
        
        let alertController = UIAlertController(title: AppStrings.getDailySignTitle(), message: AppStrings.getWhoWillSendString(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getYouString(), style: .default, handler: { (_ ) in
            // You Action
            /// Set Sender = 1
            
            self.addUserToDailySign(withUserName: withUserName, withTime: time, sender: 0)
            
        }))
        alertController.addAction(UIAlertAction(title: withUserName, style: .default, handler: { (_ ) in
            // Other User Action
            /// Set Sender = 0
            
            self.addUserToDailySign(withUserName: withUserName, withTime: time, sender: 1)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    func showContactLimitExeed() {
        let alertController = UIAlertController(title: AppStrings.getAlertString(), message: AppStrings.dsContactsAvailable(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getMoreDSContacs(), style: .default, handler: { (_ ) in
            // Move to Buy Package
            self.dismiss(animated: true) {
                self.navigateToShop?(self.userFreind)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Dismiss
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    ///
    // MARK:- ACTIONS -
    ///
    
    @IBAction func didTapSendMessage(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.openChatWitFriend?(self.userFreind)
        }
    }
    @IBAction func didTapAddInSOS(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        SOSManager.addFriendToSOS(friendID: "\(userFreind.user_id)") { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.sosButton.isUserInteractionEnabled = false
                self.sosButton.setTitle(AppStrings.getWaitingString(), for: .normal)
                self.sosButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
                NotificationCenter.default.post(name: .refreshData, object: nil, userInfo: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    @IBAction func didTapAddInOKSign(_ sender: UIButton) {
        
        self.showSpinner(onView: self.view)
        LifeSignManager.addFriendToOKSIGN(friendID: "\(userFreind.user_id)") { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.okSignButton.isUserInteractionEnabled = false
                self.okSignButton.setTitle(AppStrings.getWaitingString(), for: .normal)
                self.okSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
                NotificationCenter.default.post(name: .refreshData, object: nil, userInfo: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    fileprivate func addUserToDailySign(withUserName: String, withTime: String, sender: Int) {
        self.showSpinner(onView: self.view)
        LifeSignManager.addUserToDailySign(friendID: "\(self.userFreind.user_id)", lifeSignTime: withTime, lifeSignSender: "\(sender)") { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.lifeSignButton.isUserInteractionEnabled = false
                self.lifeSignButton.setTitle(AppStrings.getWaitingString(), for: .normal)
                self.lifeSignButton.setTitleColor(R.color.appPlaceHolderColor(), for: .normal)
                NotificationCenter.default.post(name: .refreshData, object: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @IBAction func didTapAddInLifeSign(_ sender: UIButton) {
        
        var min = Date()
        
        min = Date().addingTimeInterval(60 * 60 * 24 * (-1))
        let max = Date().addingTimeInterval(60 * 60 * 24 * 1)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
        if let availableDSContacts = UserManager.shared.userResources?.daily_sign_contact {
            if availableDSContacts > 0 {
                picker.dateFormat = "HH:mm"
                picker.includesSecond = true
                picker.highlightColor = UIColor.appBoxColor
                picker.doneButtonTitle = AppStrings.getDoneString()
                picker.isTimePickerOnly = true
                picker.cancelButtonTitle = AppStrings.getCancelString()
                picker.doneBackgroundColor = UIColor.appBoxColor
                picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: Constants.bigButtonFont)
                picker.completionHandler = { date in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    self.showLifeSignSenderAlert(withUserName: self.userFreind.first_name, time: picker.selectedDateString)
                }
                picker.delegate = self
                picker.show()
            } else {
                self.showContactLimitExeed()
            }
        }
    }
    @IBAction func didTapAddInHealth(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapBlockFriend(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        FriendManager.acceptRejectFriendRequest(requestStatus: .blocked, requestID: "\(self.userFreind.friend_request_id)") { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .refreshData, object: nil)
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    @IBAction func didTapDeleteFriend(_ sender: UIButton) {
        // self.showSpinner(onView: self.view)
        FriendManager.acceptRejectFriendRequest(requestStatus: .rejected, requestID: "\(self.userFreind.friend_request_id)") { (status, errors) in
            self.removeSpinner()
            if errors == nil {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .refreshData, object: nil)
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    ///
    // MARK:- DATE PICKER DELEGATE -
    ///
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        // print("Picker Time: \(picker.selectedDateString)")
    }
}
