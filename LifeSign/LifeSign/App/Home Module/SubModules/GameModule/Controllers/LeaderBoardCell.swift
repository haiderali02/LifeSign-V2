//
//  LeaderBoardCell.swift
//  LifeSign
//
//  Created by Haider Ali on 02/06/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SkeletonView

class LeaderBoardCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel! {
        didSet {
            numberLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.isSkeletonable = true
            userImageView.clipsToBounds = true
            userImageView.layer.cornerRadius = userImageView.frame.height * 0.5
            userImageView.layer.borderWidth = 1
            userImageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var userCupImage: UIImageView! {
        didSet {
            userCupImage.isSkeletonable = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var userPositionLabel: UILabel! {
        didSet {
            userPositionLabel.isSkeletonable = true
        }
    }
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontSize12
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
        numberLabel.showSkeleton()
        userNameLabel.showSkeleton()
        userImageView.showSkeleton()
        userPositionLabel.showSkeleton()
        userCupImage.showSkeleton()
        numberLabel.showSkeleton()
    }
    func hideAnimation() {
        numberLabel.hideSkeleton()
        userImageView.hideSkeleton()
        userNameLabel.hideSkeleton()
        userPositionLabel.hideSkeleton()
        userCupImage.hideSkeleton()
        numberLabel.hideSkeleton()
    }
    func configureCell(indexNumber: Int, userImgUrl: String, userName: String, userPostion: Int) {
        hideAnimation()
        self.numberLabel.text = "\(indexNumber)"
        self.userNameLabel.text = userName
        self.userPositionLabel.text = "\(userPostion)"
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        userImageView.backgroundColor = UIColor.appYellowColor
        
        self.userImageView.kf.indicatorType = .activity
        
        if userImgUrl != "" {
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: userImgUrl)) { (result) in
                switch result {
                case .success(_ ):
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = userName.getPrefix
                    self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = userName.getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.userImageView.image = nil
            self.namePrefixLabel.text = userName.getPrefix
        }
    }
}
