//
//  RoundUserCell.swift
//  LifeSign
//
//  Created by Haider Ali on 22/06/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class RoundUserCell: UICollectionViewCell {

    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel! {
        didSet {
            friendNameLabel.font = Constants.labelFont
        }
    }
    
    var userHealthColor: UIColor = {
        let color = UIColor.red
        return color
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
