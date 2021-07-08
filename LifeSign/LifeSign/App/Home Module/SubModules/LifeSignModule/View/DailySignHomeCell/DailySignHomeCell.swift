//
//  DailySignHomeCell.swift
//  LifeSign
//
//  Created by Haider Ali on 21/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class DailySignHomeCell: UITableViewCell {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var dailySignBtn: UIButton! {
        didSet {
            dailySignBtn.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var seeAllBtn: UIButton! {
        didSet {
            seeAllBtn.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var totalFriendsBtn: UIButton! {
        didSet {
            totalFriendsBtn.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var addNewDailySignFriendBtn: UIButton! {
        didSet {
            addNewDailySignFriendBtn.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var dailySignCollectionView: UICollectionView! {
        didSet {
            dailySignCollectionView.delegate = self
            dailySignCollectionView.dataSource = self
            dailySignCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    @IBOutlet weak var viewDailySignRequest: UIButton! {
        didSet {
            viewDailySignRequest.titleLabel?.font = Constants.backButtonFont
        }
    }
    
    lazy var componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    var userDailySignFriends: [Items] = [Items]()
    var selectedIndex: [IndexPath] = [IndexPath]()
    weak var delegate: DailySignCellProtoCol?
    var timer: Timer?
    
    // MARK:- LifeCycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addLongTapGesture()
        setText()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .languageCanged, object: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_ ) in
            UIView.performWithoutAnimation {
                self.dailySignCollectionView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .reloadNotificationView, object: nil)
    }

    @objc func setText() {
        
        seeAllBtn.setTitle(AppStrings.getSeeAllString(), for: .normal)
        addNewDailySignFriendBtn.setTitle(AppStrings.getAddNewString(), for: .normal)
        
        let reqCount = UserCounters.shared.daily_sign_friend
        
        if reqCount > 0 {
            viewDailySignRequest.setTitle(AppStrings.getViewRequestString() + " (\(reqCount))", for: .normal)
        } else {
            viewDailySignRequest.setTitle(AppStrings.getViewRequestString(), for: .normal)
        }
        
        
        self.dailySignCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
        totalFriendsBtn.setTitle(AppStrings.getFriendsString(), for: .normal)
        dailySignBtn.setTitle(AppStrings.getDailySignTitle(), for: .normal)
        self.dailySignCollectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addLongTapGesture() {
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
        let point = gestureRecognizer.location(in: dailySignCollectionView)
        
        if let indexPath = dailySignCollectionView?.indexPathForItem(at: point) {
            print("Long press at item: \(indexPath.row)")
            let userFriend = self.userDailySignFriends[indexPath.row]
            self.delegate?.displayUserDailySignInfo(userFriend: userFriend)
        }
    }
    
    @objc func didTapSendDailySign(_ sender: UIButton) {
        self.timer?.invalidate()
        self.timer = nil
        let userData = self.userDailySignFriends[sender.tag]
        LifeSignManager.sendIamSafe(dailySignID: "\(userData.daily_sign_id)") { status, errors in
            if errors == nil {
                NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
            } else {
            }
        }
    }
}


extension DailySignHomeCell: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userDailySignFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        
        cell?.leadingButton.tag = indexPath.row
        cell?.trailingButton.tag = indexPath.row
        cell?.stackView.tag = indexPath.row
        cell?.mainButton.tag = indexPath.row
        
        cell?.mainButton.addTarget(self, action: #selector(didTapSendDailySign(_:)), for: .touchUpInside)
        cell?.isFromHomeScreen = true
        
        let userData = self.userDailySignFriends[indexPath.row]
        cell?.configureCell(withName: userData.full_name, userImage: userData.profile_image, userFriend: userData)
        
        cell?.buttonContainerView.isHidden = true
        cell?.adjustImageHeigt(heigth: 40, width: 40)
        return cell ?? FriendsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            return CGSize(width: (Constants.screenWidth / 4) + 20, height: 165)
        }
        else
        {
            return CGSize(width: (Constants.screenWidth / 3) + 20, height: 165)
        }
    }
    
}
