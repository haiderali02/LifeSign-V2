//
//  FlagCell.swift
//  LifeSign
//
//  Created by Haider Ali on 16/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class FlagCell: UICollectionViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var flagName: UILabel!
    @IBOutlet weak var higlightedView: UIView!
    @IBOutlet weak var installedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        // Initialization code
    }

    func setupViews() {
        flagImageView.image = R.image.ic_pakistan()
        flagName.text = "Pakistan"
        flagName.font = R.font.robotoMedium(size: 16)
    }
}
