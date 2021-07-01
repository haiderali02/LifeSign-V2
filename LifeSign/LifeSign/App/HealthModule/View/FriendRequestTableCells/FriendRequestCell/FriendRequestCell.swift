//
//  FriendRequestCell.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
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
    @IBOutlet weak var acceptBtn: UIButton! {
        didSet {
            acceptBtn.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var rejectBtn: UIButton! {
        didSet {
            rejectBtn.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var requestStatusLabel: UILabel! {
        didSet {
            requestStatusLabel.font = Constants.labelFont
        }
    }
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
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
    
    
    func configureCell (type: String, userName: String, userImage: String) {
        
        nameLbl.text = userName
        
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
        
        
        
        switch type {
        case .pending:
            acceptBtn.isHidden = false
            rejectBtn.isHidden = false
            requestStatusLabel.isHidden = true
        case .waiting:
            acceptBtn.isHidden = true
            rejectBtn.isHidden = true
            requestStatusLabel.isHidden = false
            requestStatusLabel.text = AppStrings.getFriendPendigString()
        default:
            return
        }
        
    }
    
}
