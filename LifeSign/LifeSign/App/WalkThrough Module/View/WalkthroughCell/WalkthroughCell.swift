//
//  WalkthroughCell.swift
//  LifeSign
//
//  Created by Haider Ali on 15/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class WalkthroughCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var handImageView: UIImageView! {
        didSet {
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                handImageView.image = "ic_hand".toImage().flipHorizontally()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.font = Constants.headerSubTitleFont
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
