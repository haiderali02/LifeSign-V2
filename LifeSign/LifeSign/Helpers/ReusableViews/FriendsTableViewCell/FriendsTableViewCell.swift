//
//  FriendsTableViewCell.swift
//  LifeSign
//
//  Created by Haider Ali on 29/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import Kingfisher
import SwipeCellKit
import ImageViewer_swift
import SkeletonView

class FriendsTableViewCell: SwipeTableViewCell {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var buttonViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var buttonsBackgroundView: UIView!
    
    @IBOutlet weak var providerImage: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.clipsToBounds = true
            userImageView.layer.cornerRadius = userImageView.frame.height * 0.5
            userImageView.layer.borderWidth = 1
            userImageView.layer.borderColor = UIColor.white.cgColor
            userImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.headerSubTitleFont
            titleLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var
        rejectButton: DesignableButton! {
        didSet {
            rejectButton.titleLabel?.font = Constants.headerSubTitleFont
            rejectButton.backgroundColor = R.color.appRedColor()
            rejectButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var userImageViewHeigt: NSLayoutConstraint!
    @IBOutlet weak var userImageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var msgStatusView: UIView!
    @IBOutlet weak var seperatorView: UIView! {
        didSet {
            seperatorView.isSkeletonable = true
        }
    }
    @IBOutlet weak var seperatorViewHeigt: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = Constants.paragraphFont
            subTitleLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var trailingButton: DesignableButton! {
        didSet {
            trailingButton.titleLabel?.font = Constants.headerSubTitleFont
            trailingButton.isSkeletonable = true
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showAnimation() {
        userImageView.showSkeleton()
        namePrefixLabel.isSkeletonable = true
        namePrefixLabel.showSkeleton()
        titleLabel.showSkeleton()
        subTitleLabel.showSkeleton()
        trailingButton.isHidden = true
        rejectButton.isHidden = true
        userImageView.backgroundColor = .darkGray
    }
    func removeAnimation() {
        userImageView.hideSkeleton()
        namePrefixLabel.hideSkeleton()
        titleLabel.hideSkeleton()
        trailingButton.hideSkeleton()
        subTitleLabel.hideSkeleton()
        rejectButton.hideSkeleton()
        trailingButton.isHidden = false
        rejectButton.isHidden = false
    }
    
    
    func emptyCell(){
        rejectButton.setTitle(nil, for: .normal)
        trailingButton.setTitle(nil, for: .normal)
        namePrefixLabel.text = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
        userImageView.image = nil
        
        userImageView.layer.borderWidth = 0
        showAnimation()
    }
    
    func configureCell(withTitle: String, subTitle: String, userImage: String? = nil, type: UserCellType, userRequestStatus: String? = nil, timeAgo: String? = nil) {
        
        buttonViewWidth.constant = 90
        
        rejectButton.isHidden = true
        self.trailingButton.backgroundColor = .clear
        self.trailingButton.contentHorizontalAlignment = .right
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = R.color.appYellowColor()
        switch type {
        case .myFriend:
            
            subTitleLabel.isHidden = true
            namePrefixLabel.isHidden = true
            seperatorViewHeigt.constant = 1
            userImageViewHeigt.constant = 65
            userImageViewWidth.constant = 65
            userImageView.layer.cornerRadius = 65 / 2
            self.trailingButton.setTitle(AppStrings.getViewMoreString(), for: .normal)
            
            self.trailingButton.setTitleColor(R.color.appYellowColor(), for: .normal)
            self.trailingButton.setTitleColor(R.color.appGreenColor(), for: .selected)
            
            seperatorView.backgroundColor = R.color.appSeperatorColor()
            titleLabel.text = withTitle
            
            
            
            subTitleLabel.isHidden = true
            if userImage != "" {
                userImageView.kf.indicatorType = .activity
                userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                    switch result {
                    case .success(_ ):
                        // print(data)
                        self.namePrefixLabel.isHidden = true
                        self.namePrefixLabel.text = withTitle.getPrefix
                        self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                    case .failure(_ ):
                        // print(err.localizedDescription)
                        self.namePrefixLabel.isHidden = false
                        self.namePrefixLabel.text = withTitle.getPrefix
                    }
                }
            } else {
                self.namePrefixLabel.isHidden = false
                self.namePrefixLabel.text = withTitle.getPrefix
            }
            
            if userRequestStatus == .pending {
                
                // Accept or Reject
                buttonViewWidth.constant = 160
                self.trailingButton.setTitle(AppStrings.getAcceptString(), for: .normal)
                self.trailingButton.setTitleColor(R.color.appLightFontColor(), for: .normal)
                self.trailingButton.backgroundColor = R.color.appGreenColor()
                self.trailingButton.contentHorizontalAlignment = .center
                rejectButton.setTitle(AppStrings.getRejectString(), for: .normal)
                self.rejectButton.isHidden = false
            } else if userRequestStatus == .accepted {
                self.trailingButton.setTitleColor(R.color.appGreenColor(), for: .normal)
                self.trailingButton.setTitle(AppStrings.getViewMoreString(), for: .normal)
            } else if userRequestStatus == .blocked {
                // do Nothing
            } else if userRequestStatus == .waiting {
                buttonViewWidth.constant = 130
                self.trailingButton.setTitleColor(R.color.appOrangeColor(), for: .normal)
                self.trailingButton.setTitle(AppStrings.getFriendPendigString(), for: .normal)
            }
            
        case .people:
            subTitleLabel.isHidden = false
            seperatorViewHeigt.constant = 1
            userImageViewHeigt.constant = 65
            userImageViewWidth.constant = 65
            userImageView.layer.cornerRadius = 65 / 2
            seperatorView.backgroundColor = R.color.appSeperatorColor()
            titleLabel.text = withTitle
            subTitleLabel.text = subTitle
            
            self.trailingButton.setTitle(AppStrings.getRequestSentString(), for: .selected)
            self.trailingButton.setTitle(AppStrings.getAddFriendString(), for: .normal)
            
            self.trailingButton.setTitleColor(R.color.appYellowColor(), for: .normal)
            self.trailingButton.setTitleColor(R.color.appGreenColor(), for: .selected)
            
            if userImage != "" {
                userImageView.kf.indicatorType = .activity
                userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                    switch result {
                    case .success( _):
                        // print(data)
                        self.namePrefixLabel.isHidden = true
                        self.namePrefixLabel.text = withTitle.getPrefix
                        self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                    case .failure( _):
                        // print(err.localizedDescription)
                        self.namePrefixLabel.isHidden = false
                        self.namePrefixLabel.text = withTitle.getPrefix
                    }
                }
            } else {
                self.namePrefixLabel.isHidden = false
                self.userImageView.image = nil
                self.namePrefixLabel.text = withTitle.getPrefix
            }
            
        case .inviteFriends:
            titleLabel.text = withTitle
            subTitleLabel.text = subTitle
            userImageView.image = nil
            userImageViewHeigt.constant = 65
            userImageViewWidth.constant = 65
            userImageView.layer.cornerRadius = 65 / 2
            
            self.trailingButton.setTitle(AppStrings.getSendInviteForLifeSign(), for: .normal)
            self.trailingButton.setTitle(AppStrings.getInvitationSentString(), for: .selected)
            
            self.trailingButton.setTitleColor(R.color.appYellowColor(), for: .normal)
            self.trailingButton.setTitleColor(R.color.appGreenColor(), for: .selected)
            
            userImageView.backgroundColor = R.color.appYellowColor()
            seperatorView.backgroundColor = R.color.appSeperatorColor()
            seperatorViewHeigt.constant = 1
            userImageViewHeigt.constant = 65
            userImageViewWidth.constant = 65
            userImageView.layer.cornerRadius = 65 / 2
            namePrefixLabel.isHidden = false
            namePrefixLabel.text = withTitle.getPrefix
        case .notification:
            titleLabel.textColor = R.color.appLightFontColor()
            subTitleLabel.textColor = R.color.appLigtGray()
            seperatorViewHeigt.constant = 1
            userImageViewHeigt.constant = 56
            userImageViewWidth.constant = 56
            trailingButton.isHidden = true
            buttonsBackgroundView.isHidden = true
            userImageView.layer.cornerRadius = 56 / 2
            seperatorView.backgroundColor = R.color.appBackgroundColor()
            titleLabel.text = withTitle
            subTitleLabel.text = subTitle
            if userImage != "" {
                userImageView.kf.indicatorType = .activity
                userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                    switch result {
                    case .success(_ ):
                        // print(data)
                        self.namePrefixLabel.isHidden = true
                        self.namePrefixLabel.text = timeAgo?.getPrefix ?? ""
                        self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                    case .failure(_ ):
                        // print(err.localizedDescription)
                        self.namePrefixLabel.isHidden = false
                        self.namePrefixLabel.text = timeAgo?.getPrefix ?? ""
                    }
                }
            } else {
                self.userImageView.image = nil
                self.namePrefixLabel.isHidden = false
                self.namePrefixLabel.text = timeAgo?.getPrefix ?? ""
            }
        case .sosListing:
            titleLabel.textColor = R.color.appLightFontColor()
            subTitleLabel.textColor = R.color.appLigtGray()
            seperatorViewHeigt.constant = 5
            userImageViewHeigt.constant = 56
            userImageViewWidth.constant = 56
            
            buttonViewWidth.constant = 110
            
            trailingButton.isHidden = true
            userImageView.layer.cornerRadius = 56 / 2
            seperatorView.backgroundColor = R.color.appBackgroundColor()
            titleLabel.text = withTitle
            subTitleLabel.text = subTitle
            if userImage != "" {
                userImageView.kf.indicatorType = .activity
                userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                    switch result {
                    case .success(_ ):
                        // print(data)
                        self.namePrefixLabel.isHidden = true
                        self.namePrefixLabel.text = withTitle.getPrefix
                        self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                    case .failure(_ ):
                        // print(err.localizedDescription)
                        self.namePrefixLabel.isHidden = false
                        self.namePrefixLabel.text = withTitle.getPrefix
                    }
                }
            } else {
                self.namePrefixLabel.isHidden = false
                self.userImageView.image = nil
                self.namePrefixLabel.text = withTitle.getPrefix
            }
        case .inboxListing:
            titleLabel.textColor = R.color.appLightFontColor()
            subTitleLabel.textColor = UIColor.lightGray
            seperatorViewHeigt.constant = 1
            userImageViewHeigt.constant = 56
            userImageViewWidth.constant = 56
            rejectButton.isHidden = true
            trailingButton.isHidden = false
            trailingButton.contentHorizontalAlignment = .right
            trailingButton.titleLabel?.font = Constants.fontSize12
            trailingButton.setTitle(timeAgo, for: .normal)
            trailingButton.setTitleColor(UIColor.lightGray, for: .normal)
            userImageView.layer.cornerRadius = 56 / 2
            seperatorView.backgroundColor = R.color.appBackgroundColor()
            titleLabel.text = withTitle
            subTitleLabel.text = subTitle
            if userImage != "" {
                userImageView.kf.indicatorType = .activity
                userImageView.kf.setImage(with: URL(string: userImage ?? "")) { (result) in
                    switch result {
                    case .success(_ ):
                        // print(data)
                        self.namePrefixLabel.isHidden = true
                        self.namePrefixLabel.text = withTitle.getPrefix
                        self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                    case .failure(_ ):
                        // print(err.localizedDescription)
                        self.namePrefixLabel.isHidden = false
                        self.namePrefixLabel.text = withTitle.getPrefix
                    }
                }
            } else {
                self.userImageView.image = nil
                self.namePrefixLabel.isHidden = false
                self.namePrefixLabel.text = withTitle.getPrefix
            }
        }
    }
}


extension Collection where Element: StringProtocol {
    var initials: [Element.SubSequence] {
        return map { $0.prefix(1) }
    }
}
