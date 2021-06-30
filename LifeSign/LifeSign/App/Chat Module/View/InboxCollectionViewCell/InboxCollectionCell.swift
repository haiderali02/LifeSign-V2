//
//  InboxCollectionCell.swift
//  LifeSign
//
//  Created by Haider Ali on 22/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

class InboxCollectionCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.isSkeletonable = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.font = Constants.paragraphFont
            userNameLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var userOnlineStatus: UIImageView! {
        didSet {
            userOnlineStatus.isSkeletonable = true
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

    func configureAddMoreCell() {
        userImageView.image = R.image.ic_add_more()
        namePrefixLabel.isHidden = true
        userNameLabel.isHidden = true
        userOnlineStatus.isHidden = true
    }
    
    func showAnimation() {
        userImageView.showSkeleton()
        userNameLabel.showSkeleton()
        userOnlineStatus.isHidden = true
    }
    
    func hideAnimation() {
        userImageView.hideSkeleton()
        userNameLabel.hideSkeleton()
        userOnlineStatus.hideSkeleton()
        userOnlineStatus.isHidden = false
    }
    
    func configureUserFriend(name: String, userImage: String, onlineStatus: Bool) {
        userImageView.image = nil
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        
        if onlineStatus {
            self.userOnlineStatus.tintColor = UIColor.appGreenColor
        } else {
            self.userOnlineStatus.tintColor = UIColor.lightGray
        }
        
        userImageView.backgroundColor = R.color.appYellowColor()
        if userImage != "" {
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: userImage)) { (result) in
                switch result {
                case .success(_ ):
                    // print(data)
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = name.getPrefix
                    // self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    // print(err.localizedDescription)
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = name.getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.namePrefixLabel.text = name.getPrefix
        }
        
        self.userNameLabel.text = name
        
    }
    
}
