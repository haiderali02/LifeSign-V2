//
//  GameHeaderReusableView.swift
//  LifeSign
//
//  Created by Haider Ali on 18/05/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SkeletonView

class GameHeaderReusableView: UICollectionReusableView {

    // MARK:- OUTLETS -
   
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.font = Constants.labelFont
            userNameLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var earnBadgeTitle: UILabel! {
        didSet {
            earnBadgeTitle.font = Constants.labelFont
            earnBadgeTitle.isSkeletonable = true
        }
    }
    @IBOutlet weak var userBadgeNumber: UILabel! {
        didSet {
            userBadgeNumber.font = Constants.bigButtonFont
            userBadgeNumber.isSkeletonable = true
        }
    }
    @IBOutlet weak var currentStateLabel: UILabel! {
        didSet {
            currentStateLabel.font = Constants.labelFont
            currentStateLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var hitlisteButton: UIButton! {
        didSet {
            hitlisteButton.titleLabel?.font = Constants.labelFont
        }
    }
    
    @IBOutlet weak var btnAutoClickEnable: UIButton! {
        didSet {
            btnAutoClickEnable.titleLabel?.font = Constants.labelFont
            btnAutoClickEnable.setImage(R.image.ic_unchecked(), for: .normal)
            btnAutoClickEnable.setImage(R.image.ic_checked(), for: .selected)
            btnAutoClickEnable.isSkeletonable = true
        }
    }
    @IBOutlet weak var btnBuyMore: UIButton! {
        didSet {
            btnBuyMore.titleLabel?.font = Constants.labelFontBold
            btnBuyMore.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var btnWatchAd: UIButton! {
        didSet {
            btnWatchAd.titleLabel?.font = Constants.headerSubTitleFont
            btnWatchAd.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var userAvailableFreeGamesLabel: UILabel! {
        didSet {
            userAvailableFreeGamesLabel.font = Constants.labelFont
            userAvailableFreeGamesLabel.isSkeletonable = true
        }
    }
   
    @IBOutlet weak var btnBuyMoreGames: UIButton! {
        didSet {
            btnBuyMoreGames.titleLabel?.font = Constants.labelFontBold
            btnBuyMoreGames.isSkeletonable = true
        }
    }
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureViews()
        setText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .reloadGameHeader, object: nil)
        
    }
    
   @objc func configureViews() {
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.isSkeletonable = true
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userNameLabel.text = UserManager.shared.getUserFullName()
        userImageView.backgroundColor = R.color.appYellowColor()
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                self.namePrefixLabel.isHidden = true
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
            case .failure(_ ):
                // print(err.localizedDescription)
                self.namePrefixLabel.isHidden = false
                self.userImageView.image = nil
                self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
            }
        }
    }
    @objc func setText() {
        currentStateLabel.text = AppStrings.getCurrentStatus()
        earnBadgeTitle.text = AppStrings.getEarnedBadge()
        btnWatchAd.setTitle(AppStrings.getWatchVidTwoClicks(), for: .normal)
        btnBuyMoreGames.setTitle(AppStrings.getBuyMoreGames(), for: .normal)
        btnBuyMore.setTitle(AppStrings.getBuyAutoClicks(), for: .normal)
        btnAutoClickEnable.setTitle("\(UserManager.shared.userResources?.auto_clicked ?? 0) " + AppStrings.getAutoClicks(), for: .normal)
        btnAutoClickEnable.isSelected = UserManager.shared.enable_autoclicks
        userBadgeNumber.text = "\(UserManager.shared.game_points)"
        userAvailableFreeGamesLabel.text = AppStrings.youHaveString() + " \(UserManager.shared.userResources?.game_contact ?? 0) " + AppStrings.freeGamesString()
        
        hitlisteButton.setTitle(AppStrings.getLeaderBoardString(), for: .normal)
        
    }
    
}
