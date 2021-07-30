//
//  FriendsVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyContacts
import EmptyDataSet_Swift
import SwipeCellKit
import Cache


protocol FriendsVCDelegate: AnyObject {
    func didSelectFriend(userFriend: Items)
}

class FriendsVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var searchBarField: DesignableUITextField! {
        didSet {
            searchBarField.font = Constants.labelFont
        }
    }
    
    @IBOutlet weak var myFriendsBtn: DesignableButton! {
        didSet {
            myFriendsBtn.titleLabel?.font = Constants.headerTitleFont
        }
    }
    @IBOutlet weak var peopleBtn: DesignableButton! {
        didSet {
            peopleBtn.titleLabel?.font = Constants.headerTitleFont
        }
    }
    @IBOutlet weak var inviteFriendsBtn: DesignableButton! {
        didSet {
            inviteFriendsBtn.titleLabel?.font = Constants.headerTitleFont
        }
    }
    
    @IBOutlet weak var localPeopleBtn: DesignableButton! {
        didSet {
            localPeopleBtn.titleLabel?.font = Constants.fontSize12
            localPeopleBtn.setImage(R.image.ic_yellow_selected(), for: .selected)
            localPeopleBtn.setImage(R.image.ic_yellow_unSelected(), for: .normal)
            localPeopleBtn.setTitleColor(R.color.appYellowColor(), for: .selected)
            localPeopleBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
        }
    }
    @IBOutlet weak var internationalPeopleBtn: DesignableButton! {
        didSet {
            internationalPeopleBtn.titleLabel?.font = Constants.fontSize12
            internationalPeopleBtn.setImage(R.image.ic_yellow_selected(), for: .selected)
            internationalPeopleBtn.setImage(R.image.ic_yellow_unSelected(), for: .normal)
            internationalPeopleBtn.setTitleColor(R.color.appYellowColor(), for: .selected)
            internationalPeopleBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
        }
    }
    @IBOutlet weak var nationalPeopleBtn: DesignableButton! {
        didSet {
            nationalPeopleBtn.titleLabel?.font = Constants.fontSize12
            nationalPeopleBtn.setImage(R.image.ic_yellow_selected(), for: .selected)
            nationalPeopleBtn.setImage(R.image.ic_yellow_unSelected(), for: .normal)
            nationalPeopleBtn.setTitleColor(R.color.appYellowColor(), for: .selected)
            nationalPeopleBtn.setTitleColor(R.color.appLightFontColor(), for: .normal)
        }
    }
    
    @IBOutlet weak var friendsTableView: UITableView! {
        didSet {
            friendsTableView.estimatedRowHeight = 80
            friendsTableView.rowHeight = UITableView.automaticDimension
            friendsTableView.separatorStyle = .none
            // friendsTableView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var friendsStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var friendsTypeStackView: UIStackView!
    
    @IBOutlet weak var shareAppButton: UIButton! {
        didSet {
            shareAppButton.titleLabel?.font = Constants.headerTitleFont
        }
    }
    
    // MARK:- PROPERTIES -
    
    
    var shouldNavigateToShope: ((_ index: Int, _ value: Any?) -> Void)?
    
    var isBeingFetched = false {
        didSet {
            friendsTableView.reloadData()
        }
    }
    
    weak var delegates: FriendsVCDelegate?
    
    var paginationLinks: Links?
    
    var refreshControl = UIRefreshControl()
    
    var filterPhoneContacts: [CNContact] = [CNContact]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }
    
    var userContacts: [CNContact] = [CNContact]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }
    var userFriendsData: [Items] = [Items]()
    var peopleData: [Items] = [Items]()
    
    var timer: Timer? = nil
    var friendsTypeView: UserCellType = .myFriend
    
    var currentPageNumber: Int = 1
    
    var mode: FriendsScreenMode = {
        return .friends
    }()
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setText()
        observerLanguageChange()
        
    }
    
    // MARK:- FUNCTIONS -
    
    @objc func setupUI() {
        friendsTableView.register(R.nib.friendsTableViewCell)
        self.didTapMyFriends(self.myFriendsBtn)
        
        self.friendsTableView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        friendsTableView.addSubview(refreshControl)
        
        searchBarField.addTarget(self, action: #selector(handleSearchBar), for: .editingChanged)
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.ic_cross() ?? UIImage(), style: .plain, target: self, action: #selector(didTapBack(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.yellow
        
        switch mode {
        case .friends:
            friendsStackViewHeight.constant = 50
            friendsTypeStackView.isHidden = false
        case .Inbox:
            friendsStackViewHeight.constant = 0
            friendsTypeStackView.isHidden = true
        case .addNew:
            friendsStackViewHeight.constant = 0
            friendsTypeStackView.isHidden = true
        case .game:
            friendsStackViewHeight.constant = 0
            friendsTypeStackView.isHidden = true
        }
        
    }
    
    @objc func setText() {
        self.peopleBtn.setTitle(AppStrings.getPeopleTitle(), for: .normal)
        self.myFriendsBtn.setTitle(AppStrings.getTabFriendsTitle(), for: .normal)
        self.inviteFriendsBtn.setTitle(AppStrings.getInviteFriendsTitle(), for: .normal)
        self.localPeopleBtn.setTitle(AppStrings.getTabLocalFriendsTitle(), for: .normal)
        self.internationalPeopleBtn.setTitle(AppStrings.getInternationalFriendTitle(), for: .normal)
        self.nationalPeopleBtn.setTitle(AppStrings.getNationalFriendTitle(), for: .normal)
        self.searchBarField.placeholder = AppStrings.getSearchString()
        self.navigationItem.title = mode == .Inbox ? AppStrings.getNewChatString() : AppStrings.getFriendsString()
        self.friendsTableView.reloadData()
        shareAppButton.setTitle(AppStrings.shareLifeSign(), for: .normal)
       
    }
    
    @objc func handleSearchBar() {
        // print("SearchText: \(searchBarField.text ?? "")")
        NSObject.cancelPreviousPerformRequests(
                withTarget: self,
                selector: #selector(self.getTextFromSearchField),
                object: searchBarField)
            self.perform(
                #selector(self.getTextFromSearchField),
                with: searchBarField,
                afterDelay: 0.5)
    }
    
    @objc func getTextFromSearchField(textField: UITextField) {
        guard let searchString = textField.text else {return}
        self.handleSearch(searchString: searchString)
    }
    
    @objc func refreshData() {
        self.didTapMyFriends(self.myFriendsBtn)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        switch friendsTypeView {
        case .myFriend:
            self.didTapMyFriends(self.myFriendsBtn)
        case .people:
            if self.localPeopleBtn.isSelected {
                self.didTapLocalPerson(self.localPeopleBtn)
            } else if self.internationalPeopleBtn.isSelected {
                self.didTapInternationalPerson(self.internationalPeopleBtn)
            } else if self.nationalPeopleBtn.isSelected {
                self.didTapNationalPeroson(self.nationalPeopleBtn)
            } else {
                self.didTapPeople(self.peopleBtn)
            }
        case .inviteFriends:
            self.didTapInviteFriends(self.inviteFriendsBtn)
        default:
            return
        }
    }
    
    @objc func didTapBack(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .refreshData, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapShareApp(_ sender: UIButton) {
        sender.showAnimation {
            UIApplication.share(sourceView: sender, AppStrings.getShareLifeSign())
        }
    }
    @IBAction func didTapMyFriends(_ sender: UIButton) {
        currentPageNumber = 1
        myFriendsBtn.isSelected = true
        peopleBtn.isSelected = false
        inviteFriendsBtn.isSelected = false
        friendsTypeView = .myFriend
        self.searchBarField.text = ""
        self.handleFriendsButtonTapped()
    }
    @IBAction func didTapPeople(_ sender: UIButton) {
        currentPageNumber = 1
        self.peopleData.removeAll()
        myFriendsBtn.isSelected = false
        peopleBtn.isSelected = true
        inviteFriendsBtn.isSelected = false
        friendsTypeView = .people
        self.searchBarField.text = ""
        self.handlePeopleButtonTapped()
    }
    
    @IBAction func didTapInviteFriends(_ sender: UIButton) {
        myFriendsBtn.isSelected = false
        peopleBtn.isSelected = false
        inviteFriendsBtn.isSelected = true
        friendsTypeView = .inviteFriends
        self.searchBarField.text = ""
        self.handleInviteFriendsTapped()
    }
    
    
    @IBAction func didTapLocalPerson(_ sender: UIButton) {
        self.currentPageNumber = 1
        localPeopleBtn.isSelected = true
        internationalPeopleBtn.isSelected = false
        nationalPeopleBtn.isSelected = false
        self.searchBarField.text = ""
        self.getLifeSignUsers(type: .local, searchString: nil, pageNumer: self.currentPageNumber)
    }
    
    @IBAction func didTapInternationalPerson(_ sender: UIButton) {
        self.currentPageNumber = 1
        localPeopleBtn.isSelected = false
        internationalPeopleBtn.isSelected = true
        nationalPeopleBtn.isSelected = false
        self.searchBarField.text = ""
        self.getLifeSignUsers(type: .international, searchString: nil, pageNumer: self.currentPageNumber)
    }
    @IBAction func didTapNationalPeroson(_ sender: UIButton) {
        self.currentPageNumber = 1
        localPeopleBtn.isSelected = false
        internationalPeopleBtn.isSelected = false
        nationalPeopleBtn.isSelected = true
        self.searchBarField.text = ""
        self.getLifeSignUsers(type: .national, searchString: nil, pageNumer: self.currentPageNumber)
    }
    
    @objc func didTapRejectButton(_ sender: UIButton) {
        sender.showAnimation {
            // Reject Request
            let user = self.userFriendsData[sender.tag]
            self.showSpinner(onView: self.view)
            FriendManager.acceptRejectFriendRequest(requestStatus: .rejected, requestID: "\(user.friend_request_id)") { (status, errors) in
                self.removeSpinner()
                if errors == nil {
                    self.userFriendsData.removeAll { friendObj in
                        return friendObj.friend_request_id == user.friend_request_id
                    }
                    self.friendsTableView.reloadData()
                    self.removeSpinner()
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
    }
    fileprivate func sendGameRequest(_ myFrnd: Items) {
        self.showSpinner(onView: self.view)
        GameManager.sendGameFriendRequest(friend_ID: myFrnd.user_id) { status, errors in
            self.removeSpinner()
            if errors == nil {
                self.didTapMyFriends(self.myFriendsBtn)
                NotificationCenter.default.post(name: .reloadGameScreen, object: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    @objc func didTapTrailingCellButton(_ sender: UIButton) {
        sender.showAnimation {
            if self.mode == .game {
                // Send game Request To Friend --
                let myFrnd = self.userFriendsData[sender.tag]
            
                if myFrnd.game_request == .pending {
                    return
                } else if myFrnd.game_request == .waiting {
                    return
                } else {
                    self.sendGameRequest(myFrnd)
                }
            } else {
                self.handleTrailingButtonTapped(view: self.friendsTypeView, userIndex: sender.tag)
            }
        }
    }
}


extension FriendsVC: ListViewMethods, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch friendsTypeView {
        case .myFriend:
            return self.isBeingFetched ? 10 : userFriendsData.count
        case .people:
            return self.isBeingFetched ? 10 : self.peopleData.count
        case .inviteFriends:
            if self.searchBarField.text != "" {
                return self.isBeingFetched ? 10 : self.filterPhoneContacts.count
            } else {
                return self.isBeingFetched ? 10 : self.userContacts.count
            }
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsTableViewCell, for: indexPath)
        
        
        friendCell?.titleLabel.text = nil
        friendCell?.userImageView.image = nil
        friendCell?.subTitleLabel.text = nil
        friendCell?.namePrefixLabel.text = nil
        friendCell?.delegate = self
        // friendCell?.accessoryType = .disclosureIndicator
        friendCell?.contentView.superview?.backgroundColor = R.color.appBoxesColor()
        
        friendCell?.trailingButton.tag = indexPath.row
        friendCell?.rejectButton.tag = indexPath.row
        
        friendCell?.trailingButton.addTarget(self, action: #selector(self.didTapTrailingCellButton(_:)), for: .touchUpInside)
        friendCell?.rejectButton.addTarget(self, action: #selector(self.didTapRejectButton(_:)), for: .touchUpInside)
        friendCell?.emptyCell()
        switch friendsTypeView {
        case .myFriend:
            
            if !self.isBeingFetched {
                friendCell?.removeAnimation()
                let myFrnd = self.userFriendsData[indexPath.row]
                friendCell?.userImageView.image = nil
                
                if myFrnd.provider == .app {
                    friendCell?.providerImage.image = R.image.ic_email_head()
                } else if myFrnd.provider == .facebook {
                    friendCell?.providerImage.image = R.image.ic_facebook_headd()
                } else if myFrnd.provider == .apple {
                    friendCell?.providerImage.image = R.image.ic_apple_head()
                }
                
                friendCell?.configureCell(withTitle: myFrnd.first_name + " " + myFrnd.last_name, subTitle: myFrnd.timezone, userImage: myFrnd.profile_image , type: .myFriend, userRequestStatus: myFrnd.request_status)
                friendCell?.trailingButton.isHidden = mode == .Inbox ? true : false
                
                if mode == .game {
                    if myFrnd.game_request == .pending {
                        friendCell?.trailingButton.setTitleColor(.lightGray, for: .normal)
                        friendCell?.trailingButton.setTitle(AppStrings.gameInvitationSent(), for: .normal)
                    } else if myFrnd.game_request == .waiting {
                        friendCell?.trailingButton.setTitleColor(.lightGray, for: .normal)
                        friendCell?.trailingButton.setTitle(AppStrings.gameInvitationReceived(), for: .normal)
                    } else if myFrnd.game_request == .accepted {
                        friendCell?.trailingButton.isHidden = true
                    } else {
                        friendCell?.trailingButton.setTitleColor(R.color.appDarkGreenColor(), for: .normal)
                        friendCell?.trailingButton.setTitle(AppStrings.getSendInviteForLifeSign(), for: .normal)
                    }
                }
                
            } else {
                friendCell?.showAnimation()
            }
            return friendCell ?? FriendsTableViewCell()
        case .people:
            
            if !self.isBeingFetched {
                let person = self.peopleData[indexPath.row]
                friendCell?.removeAnimation()
                friendCell?.userImageView.image = nil
                
                if person.provider == .app {
                    friendCell?.providerImage.image = R.image.ic_email_head()
                } else if person.provider == .facebook {
                    friendCell?.providerImage.image = R.image.ic_facebook_headd()
                } else if person.provider == .apple {
                    friendCell?.providerImage.image = R.image.ic_apple_head()
                }
                
                friendCell?.configureCell(withTitle: person.first_name + " " + person.last_name, subTitle: person.timezone, userImage: person.profile_image , type: .people)
            } else {
                friendCell?.showAnimation()
            }
            return friendCell ?? FriendsTableViewCell()
        case .inviteFriends:
            if searchBarField.text != "" {
                
                if !self.isBeingFetched {
                    friendCell?.removeAnimation()
                    let contact = self.filterPhoneContacts[indexPath.row]
                    let contactName = CNContactFormatter.string(from: contact, style: .fullName)
                    var contactNumber = ""
                    friendCell?.userImageView.image = nil
                    if contact.phoneNumbers.count > 0{
                        contactNumber = ((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                    }
                    friendCell?.providerImage.image = nil
                    
                    friendCell?.configureCell(withTitle: contactName ?? "Unknown", subTitle: contactNumber, userImage: nil, type: .inviteFriends)
                } else {
                    friendCell?.showAnimation()
                }
                return friendCell ?? FriendsTableViewCell()
            } else {
                
                if !self.isBeingFetched {
                    friendCell?.removeAnimation()
                    let contact = self.userContacts[indexPath.row]
                    let contactName = CNContactFormatter.string(from: contact, style: .fullName)
                    var contactNumber = ""
                    friendCell?.userImageView.image = nil
                    if contact.phoneNumbers.count > 0{
                        contactNumber = ((contact.phoneNumbers[0].value ).value(forKey: "digits") as! String)
                    }
                    friendCell?.providerImage.image = nil
                    friendCell?.configureCell(withTitle: contactName ?? "Unknown", subTitle: contactNumber, userImage: nil, type: .inviteFriends)
                } else {
                    friendCell?.showAnimation()
                }
                return friendCell ?? FriendsTableViewCell()
            }
            
        default:
            return FriendsTableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if mode == .Inbox {
            self.dismiss(animated: true) {
                let myFrnd = self.userFriendsData[indexPath.row]
                self.delegates?.didSelectFriend(userFriend: myFrnd)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch friendsTypeView {
        case .myFriend:
            if indexPath.row == (self.userFriendsData.count - 1) {
                guard let link = paginationLinks else {return}
                if (link.last_page != self.currentPageNumber) && (link.last_page > self.currentPageNumber) {
                    self.currentPageNumber += 1
                    self.getUserFriends(searcString: nil, pageNumer: self.currentPageNumber, userLimit: nil)
                }
            }
        case .people:
            if indexPath.row == (self.peopleData.count - 1) {
                guard let link = paginationLinks else {return}
                if (link.last_page != self.currentPageNumber) && (link.last_page > self.currentPageNumber) {
                    self.currentPageNumber += 1
                    if self.localPeopleBtn.isSelected {
                        self.getLifeSignUsers(type: .local, searchString: nil, pageNumer: currentPageNumber)
                    } else if self.internationalPeopleBtn.isSelected {
                        self.getLifeSignUsers(type: .international, searchString: nil, pageNumer: currentPageNumber)
                    } else if self.nationalPeopleBtn.isSelected {
                        self.getLifeSignUsers(type: .national, searchString: nil, pageNumer: currentPageNumber)
                    }
                }
            }
        case .inviteFriends:
            // All Contact Loaded at once, so don't need pagination
            print("Displaying Invite Friends")
        default:
            return
        }
    }
    
    
    // MARK:- TABLEVIEW EDIT ACTIONS -
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        if self.myFriendsBtn.isSelected {
            let deleteAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                let friend = self.userFriendsData[indexPath.row]
                self.showSpinner(onView: self.view)
                FriendManager.acceptRejectFriendRequest(requestStatus: .rejected, requestID: "\(friend.friend_request_id)") { (status, errors) in
                    self.removeSpinner()
                    if errors == nil {
                        self.userFriendsData.remove(at: indexPath.row)
                        self.friendsTableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.removeSpinner()
                }
                
            }
            deleteAction.image = UIImage(named: "ic_delete")
            return [deleteAction]
        } else {
            return nil
        }
    }
}



