//
//  HealthHomeCell.swift
//  LifeSign
//
//  Created by Haider Ali on 22/06/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import Kingfisher
import ImageViewer_swift

protocol HealthCellDelegates: AnyObject {
    func didTapFriendCell(at index: Int)
}

class HealthHomeCell: UITableViewCell {

    @IBOutlet weak var btnHealth: UIButton! {
        didSet {
            btnHealth.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var btnSeeAll: UIButton! {
        didSet {
            btnSeeAll.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var currentHeartBeatLabel: UILabel!
    @IBOutlet weak var heartBeatUnit: UILabel!
    @IBOutlet weak var userDeepSleep: UILabel!
    @IBOutlet weak var userBurntCalories: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var caloriesUnitLabel: UILabel!
    @IBOutlet weak var deepSleepLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var userStepsCount: UILabel!
    @IBOutlet weak var friendsCountLabel: UIButton!  {
        didSet {
            friendsCountLabel.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var addNewFriendLabel: UIButton! {
        didSet {
            addNewFriendLabel.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var viewRequestLabel: UIButton! {
        didSet {
            viewRequestLabel.titleLabel?.font = Constants.backButtonFont
        }
    }
    @IBOutlet weak var friendsCollectionView: UICollectionView! {
        didSet {
            friendsCollectionView.delegate = self
            friendsCollectionView.dataSource = self
            friendsCollectionView.register(R.nib.roundUserCell)
        }
    }
    
    weak var delegates: HealthCellDelegates?
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setText()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setText), name: .languageCanged, object: nil)
        // Initialization code
    }

    @objc func setText() {
       
        btnSeeAll.setTitle(AppStrings.getSeeAllString(), for: .normal)
        friendsCountLabel.setTitle(AppStrings.getFriendsString(), for: .normal)
        viewRequestLabel.setTitle(AppStrings.getViewRequestString(), for: .normal)
        addNewFriendLabel.setTitle(AppStrings.getAddNewString(), for: .normal)
        
        userNameLabel.text = UserManager.shared.getUserFullName()
        userProfileImage.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userProfileImage)
        }
        userProfileImage.backgroundColor = R.color.appYellowColor()
        
        userProfileImage.kf.indicatorType = .activity
        
        userProfileImage.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                self.namePrefixLabel.isHidden = true
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                
            case .failure(_ ):
                // print(err.localizedDescription)
                self.namePrefixLabel.isHidden = false
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HealthHomeCell: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.roundUserCell, for: indexPath)
        return cell ?? RoundUserCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegates?.didTapFriendCell(at: indexPath.row)
    }
    
}
