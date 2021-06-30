//
//  SOSMultiAlertVC.swift
//  LifeSign
//
//  Created by Haider Ali on 14/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import SwiftySound

class SOSMultiAlertVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var friendsCollectionView: UICollectionView! {
        didSet {
            friendsCollectionView.delegate = self
            friendsCollectionView.dataSource = self
            friendsCollectionView.register(R.nib.friendsCollectionViewCell)
        }
    }
    
    // MARK:- PROPERTIES -
    
    var sosReceived: [SOSReceivedAlert] = [SOSReceivedAlert]()
    
    var userFriendsData: [Items] = [Items]()
    var paginationLinks: Links?
    var refreshControl = UIRefreshControl()
    
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
        // Sound.stop(file: .sosReceived)
        Sound.stopAll()
        UserDefaults.standard.setValue(false, forKey: .sosMultiScreenAppeared)
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        UserDefaults.standard.setValue(true, forKey: .sosMultiScreenAppeared)
        Sound.play(file: .sosReceived)
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getSOSTitle(), for: .normal)
        titleLable.text = AppStrings.getSOSTitle()
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        sender.showAnimation {
            self.pop(controller: self)
        }
    }
    
    @objc func didTapLeadingButton(_ sender: UIButton) {
        
    }
    @objc func didTapGotIt(_ sender: UIButton) {
        let userData = sosReceived[sender.tag]
        sender.showAnimation {

        }
        self.showSpinner(onView: self.view)
        SOSManager.markAllSOSSeen(friendID: "\(userData.friend_id)") { (status, errors) in
            self.removeSpinner()
            self.sosReceived.removeAll { (sosRec) -> Bool in
                userData.friend_id == sosRec.friend_id
            }
            self.friendsCollectionView.reloadData()
            if self.sosReceived.count == 0 {
                self.pop(controller: self)
            }
        }
    }
}


extension SOSMultiAlertVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sosReceived.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.friendsCollectionViewCell, for: indexPath)
        cell?.emptyCell()
        cell?.leadingButton.tag = indexPath.row
        cell?.trailingButton.tag = indexPath.row
        cell?.stackView.tag = indexPath.row
        
        cell?.leadingButton.addTarget(self, action: #selector(didTapLeadingButton(_:)), for: .touchUpInside)
        cell?.trailingButton.addTarget(self, action: #selector(didTapGotIt(_:)), for: .touchUpInside)
        let userData = sosReceived[indexPath.row]
        cell?.configureCellForOKSign(withName: userData.full_name, userImage: userData.profile_image, state: .checkFriend)
        cell?.mainButton.tag = indexPath.row
        cell?.userTimeZoneLabel.text = userData.timezone
        cell?.trailingButton.setTitle(AppStrings.sosGotIT(), for: .normal)
        cell?.mainButton.addTarget(self, action: #selector(didTapCardView(_:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat,.autoreverse], animations: {
            cell?.userImageView.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
            cell?.userNameLabel.transform = CGAffineTransform(scaleX: 1.12, y: 1.12)
        }, completion: nil)
        
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
        
    }
}
