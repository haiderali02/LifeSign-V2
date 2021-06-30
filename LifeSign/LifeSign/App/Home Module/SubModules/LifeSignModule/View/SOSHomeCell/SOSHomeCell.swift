//
//  SOSHomeCell.swift
//  LifeSign
//
//  Created by Haider Ali on 06/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import PopBounceButton
import EmptyDataSet_Swift

class SOSHomeCell: UITableViewCell {

    @IBOutlet weak var sosButton: UIButton! {
        didSet {
            sosButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var seeAllButton: UIButton! {
        didSet {
            seeAllButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var sosMainButton: UIButton! {
        didSet {
            sosMainButton.setBackgroundImage(R.image.ic_sos_sent(), for: .disabled)
            sosMainButton.setBackgroundImage(R.image.ic_sos_normal(), for: .normal)
            sosMainButton.tintColor = .systemRed
            sosMainButton.titleLabel?.font = Constants.sosLargeButtonFont
        }
    }
    @IBOutlet weak var sosAddNewButton: UIButton! {
        didSet {
            sosAddNewButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var totalFriendsButton: UIButton! {
        didSet {
            totalFriendsButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var viewRequestButton: UIButton! {
        didSet {
            viewRequestButton.titleLabel?.font = Constants.backButtonFont
        }
    }
    
    @IBOutlet weak var sosFriendsCollectionView: UICollectionView! {
        didSet {
            sosFriendsCollectionView.delegate = self
            sosFriendsCollectionView.dataSource = self
            
            sosFriendsCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    var userSOSFriends: [Items] = [Items]()
    var selectedIndex: [IndexPath] = [IndexPath]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setText()
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .reloadNotificationView, object: nil)
    }

    func setUI () {
        sosMainButton.setBackgroundImage(R.image.ic_sos_sent(), for: .disabled)
        sosMainButton.setBackgroundImage(R.image.ic_sos_normal(), for: .normal)
        sosMainButton.tintColor = .systemRed
        sosMainButton.titleLabel?.font = Constants.sosLargeButtonFont
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func setText() {
        sosButton.setTitle(AppStrings.getSOSTitle(), for: .normal)
        seeAllButton.setTitle(AppStrings.getSeeAllString(), for: .normal)
        sosMainButton.setTitle(AppStrings.getPushForThreeSecString(), for: .normal)
        sosAddNewButton.setTitle(AppStrings.getAddNewString(), for: .normal)
        
        let sosReqCount = UserCounters.shared.sos_friend
        
        if sosReqCount > 0 {
            viewRequestButton.setTitle(AppStrings.getViewRequestString() + " (\(sosReqCount))", for: .normal)
        } else {
            viewRequestButton.setTitle(AppStrings.getViewRequestString(), for: .normal)
        }
        
        
        
        self.sosFriendsCollectionView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
    }
}

extension SOSHomeCell: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userSOSFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        cell?.emptyCell()
        let userFriend = self.userSOSFriends[indexPath.row]
        cell?.buttonContainerView.isHidden = userFriend.sos_request == .accepted ? true : false
        cell?.cardView.tag = indexPath.row
        cell?.userTimeZoneLabel.isHidden = userFriend.sos_request == .accepted ? false : true
        cell?.userTimeZoneLabel.text = userFriend.timezone
        cell?.configureCell(withName: userFriend.first_name + " " + userFriend.last_name, userImage: userFriend.profile_image)
        cell?.userTimeZoneLabel.isHidden = true
        cell?.cardView.backgroundColor = R.color.appRedColor()
        cell?.adjustImageHeigt(heigth: 40, width: 40)
        return cell ?? FriendsCollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            return CGSize(width: Constants.screenWidth / 4, height: 125)
        }
        else
        {
            return CGSize(width: Constants.screenWidth / 3, height: 125)
        }
    }
}
