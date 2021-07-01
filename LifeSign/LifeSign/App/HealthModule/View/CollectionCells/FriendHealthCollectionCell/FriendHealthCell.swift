//
//  FriendHealthCell.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class FriendHealthCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!{
        didSet{
            profileImage.layer.cornerRadius = profileImage.frame.height / 2
        }
    }
    @IBOutlet weak var nameLbl: UILabel! {
        didSet {
            nameLbl.font = Constants.labelFont
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

    
    func configureCell(userImage: String, userName: String, healthColor: String) {
        
        profileImage.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(profileImage)
        }
        profileImage.backgroundColor = UIColor.appYellowColor
        self.nameLbl.text = userName
        if userImage != "" {
            profileImage.kf.indicatorType = .activity
            profileImage.kf.setImage(with: URL(string: userImage)) { (result) in
                switch result {
                case .success(_ ):
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = userName.getPrefix
                    self.profileImage.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = userName.getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.profileImage.image = nil
            self.namePrefixLabel.text = userName.getPrefix
        }
        
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor  = UIColor(hex: healthColor)?.cgColor
        
    }
    
}
