//
//  DailySignVC.swift
//  LifeSign
//
//  Created by Haider Ali on 21/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class DailySignVC: LifeSignBaseVC, UIGestureRecognizerDelegate {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var dailySignSegmentBar: UISegmentedControl! {
        didSet {
            let unSelectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appYellowColor]
            let selectedAttribute = [NSAttributedString.Key.foregroundColor: UIColor.appBoxColor]
            dailySignSegmentBar.setTitleTextAttributes(unSelectedAttribute, for: .normal)
            dailySignSegmentBar.setTitleTextAttributes(selectedAttribute, for: .selected)
            dailySignSegmentBar.selectedSegmentTintColor = UIColor.appYellowColor
        }
    }
    
    @IBOutlet weak var dailySignCollectionView: UICollectionView! {
        didSet {
            dailySignCollectionView.delegate = self
            dailySignCollectionView.dataSource = self
            dailySignCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    // MARK:- PROPERTIES -
    
    var allowedDSContacts: Int = 0
    
    var isBeingFetched = false {
        didSet {
            dailySignCollectionView.reloadData()
        }
    }
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    var mode: DailySignMode = {
        return .allFriends
    }()
    
    var selectedIndex: [IndexPath] = [IndexPath]()
    
    var paginationLinks: Links?
    var refreshControl = UIRefreshControl()
    
    var dailySignFriends: [Items] = [Items]()
    var friendsRequests: [Items] = [Items]()
    
    var timer: Timer?
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        dailySignCollectionView.addSubview(refreshControl)
        self.dailySignCollectionView!.alwaysBounceVertical = true
        self.dailySignCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        getUserDailySignFriends(searchString: nil)
        
        switch mode {
        case .allFriends:
            print("Open All friends")
            self.dailySignSegmentBar.selectedSegmentIndex = 0
            self.didChangeTabs(self.dailySignSegmentBar)
        case .friendRequest:
            self.dailySignSegmentBar.selectedSegmentIndex = 1
            self.didChangeTabs(self.dailySignSegmentBar)
            print("Open Requests")
        }
        
        self.setupLongGestureRecognizerOnCollection()
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if dailySignSegmentBar.selectedSegmentIndex == 0 {
            self.dailySignFriends.removeAll()
            self.selectedIndex.removeAll()
            self.dailySignCollectionView.reloadData()
            getUserDailySignFriends(searchString: nil)
            
        } else {
            self.friendsRequests.removeAll()
            self.selectedIndex.removeAll()
            self.dailySignCollectionView.reloadData()
            getUserDailySignRequest(searchString: nil)
        }
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 1.0
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        dailySignCollectionView?.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let p = gestureRecognizer.location(in: dailySignCollectionView)
        
        if let indexPath = dailySignCollectionView?.indexPathForItem(at: p) {
            print("Long press at item: \(indexPath.row)")
            if self.dailySignSegmentBar.selectedSegmentIndex == 0 {
                let userData = dailySignFriends[indexPath.row]
                self.displayUserDailySignInfo(userFriend: userData)
            }
        }
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getDailySignTitle(), for: .normal)
        dailySignSegmentBar.setTitle(AppStrings.getLSFriends(), forSegmentAt: 0)
        dailySignSegmentBar.setTitle(AppStrings.getFriendRequestString(), forSegmentAt: 1)
        self.dailySignCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
    }
    
    
    func updateRequestStatus(status: String, userData: Items) {
        self.showSpinner(onView: self.view)
        LifeSignManager.acceptRejectDailySignReq(friendID: "\(userData.friend_id)", requestStaus: status) { status, errors in
            self.removeSpinner()
            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            if errors == nil {
                self.refresh(self.refreshControl)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func showCancelRequestAlert(userData: Items) {
        // Reject The Request or Cancel The Pending Request
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelRequestString(), style: .destructive, handler: { (_ ) in
            // Hit Cancel Request API
            self.updateRequestStatus(status: .cancel, userData: userData)
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Simply dismiss
        }))
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.dailySignCollectionView
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getUserDailySignFriends(searchString: String?) {
        self.isBeingFetched = true
        LifeSignManager.getUserDailySignFriends(searchString: searchString, limit: nil, PageNumber: nil) { (friendsData, allowedContacts, errors, links) in
            self.refreshControl.endRefreshing()
            self.isBeingFetched = false
            if let contacts = allowedContacts {
                self.allowedDSContacts = contacts
            }
            
            if errors == nil {
                self.dailySignFriends.removeAll()
                self.dailySignCollectionView.reloadData()
                if let userOkFriends = friendsData?.items {
                    
                    for user in userOkFriends {
                        self.dailySignFriends.append(user)
                    }
                    self.dailySignCollectionView.reloadData()
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    func getUserDailySignRequest(searchString: String?) {
        self.isBeingFetched = true
        LifeSignManager.getDailySignRequests(searchString: searchString, limit: nil, PageNumber: nil) { (friendsData, errors, links) in
            self.refreshControl.endRefreshing()
            self.isBeingFetched = false
            if errors == nil {
                self.friendsRequests.removeAll()
                self.dailySignCollectionView.reloadData()
                if let userOkFriends = friendsData?.items {
                    for user in userOkFriends {
                        self.friendsRequests.append(user)
                    }
                    self.dailySignCollectionView.reloadData()
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    
    func showUserFriends() {
        if let controller = R.storyboard.friends.friendsVC() {
            controller.modalPresentationStyle = .overCurrentContext
            controller.mode = .addNew
            controller.shouldNavigateToShope = { (index, value) in
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .redirectToShop, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .overFullScreen
            
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: .refreshHomeScreen, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didChangeTabs(_ sender: UISegmentedControl) {
       
        if sender.selectedSegmentIndex == 0 {
            self.dailySignFriends.removeAll()
            self.selectedIndex.removeAll()
            self.dailySignCollectionView.reloadData()
            getUserDailySignFriends(searchString: nil)
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_ ) in
                self.dailySignCollectionView.reloadData()
            }
        } else {
            self.timer?.invalidate()
            self.timer = nil
            self.friendsRequests.removeAll()
            self.selectedIndex.removeAll()
            self.dailySignCollectionView.reloadData()
            getUserDailySignRequest(searchString: nil)
        }
    }
    
    @IBAction func didTapAddFriend(_ sender: UIButton) {
        showUserFriends()
    }
    
    @IBAction func didTapInfo(_ sender: UIButton) {
        if let controller = R.storyboard.walkThrough.dailySignInfoVC() {
            controller.showBackButton = true
            self.present(controller, animated: true, completion: nil)
        }
    }
    @objc func didTapLeadingButton(_ sender: UIButton) {
        print("Hello Leading")
        self.timer?.invalidate()
        self.timer = nil
        let userData = self.friendsRequests[sender.tag]
        self.updateRequestStatus(status: .accepted, userData: userData)
    }
    @objc func didTapTrailingButton(_ sender: UIButton) {
        print("Hello Trailing")
        self.timer?.invalidate()
        self.timer = nil
        let userData = self.friendsRequests[sender.tag]
        self.updateRequestStatus(status: .rejected, userData: userData)
    }
    @objc func didTapSendDailySign(_ sender: UIButton) {
        sender.showAnimation {
            
        }
        print("I am Enable")
        self.showSpinner(onView: self.view)
        self.timer?.invalidate()
        self.timer = nil
        let userData = self.dailySignFriends[sender.tag]
        LifeSignManager.sendIamSafe(dailySignID: "\(userData.daily_sign_id)") { status, errors in
            self.removeSpinner()
            if errors == nil {
                self.refresh(self.refreshControl)
                NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
}

extension DailySignVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailySignSegmentBar.selectedSegmentIndex == 0 ? (self.isBeingFetched ? 6 : self.dailySignFriends.count) : (self.isBeingFetched ? 6 : self.friendsRequests.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        
        
        cell?.leadingButton.tag = indexPath.row
        cell?.trailingButton.tag = indexPath.row
        cell?.stackView.tag = indexPath.row
        cell?.mainButton.tag = indexPath.row
        
        cell?.leadingButton.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
        cell?.trailingButton.addTarget(self, action: #selector(didTapTrailingButton(_:)), for: .touchUpInside)
        cell?.mainButton.addTarget(self, action: #selector(didTapSendDailySign(_:)), for: .touchUpInside)
        
        cell?.userTimeZoneLabel.isHidden = false
        cell?.buttonContainerView.isHidden = true
        cell?.emptyCell()
        
        if (isBeingFetched) && (self.dailySignSegmentBar.selectedSegmentIndex == 0) {
            cell?.showAnimation()
            return cell ?? FriendsCollectionViewCell()
        }
        if (isBeingFetched) && (self.dailySignSegmentBar.selectedSegmentIndex != 0) {
            cell?.showAnimation()
            return cell ?? FriendsCollectionViewCell()
        }
        let userData = self.dailySignSegmentBar.selectedSegmentIndex == 0 ? dailySignFriends[indexPath.row] : friendsRequests[indexPath.row]
        cell?.hideAnimation()
        if self.dailySignSegmentBar.selectedSegmentIndex == 0 {
            cell?.configureCell(withName: userData.full_name, userImage: userData.profile_image, userFriend: userData)
      
        } else {
            cell?.configureCell(withName: userData.first_name + " " + userData.last_name, userImage: userData.profile_image, userFriend: userData)
        }
        
        return cell ?? FriendsCollectionViewCell()
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
    
    @objc func didTapCardView(_ sender: UIButton) {
        let userData = dailySignSegmentBar.selectedSegmentIndex == 0 ? dailySignFriends[sender.tag] : friendsRequests[sender.tag]
        
        print("Hello Users \(userData.first_name)")
    }
    
    
    func displayUserDailySignInfo(userFriend: Items?) {
        if let controller = R.storyboard.lifeSign.editDailySignVC() {
            controller.definesPresentationContext = true
            controller.userFreind = userFriend
            controller.modalPresentationStyle = .overCurrentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
