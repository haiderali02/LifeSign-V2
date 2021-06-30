//
//  ShopCell.swift
//  LifeSign
//
//  Created by Haider Ali on 26/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SkeletonView

class ShopCell: UITableViewCell {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.font = Constants.labelFont
            priceLabel.isSkeletonable = true
        }
    }
    @IBOutlet weak var priceButton: UIButton! {
        didSet {
            priceButton.titleLabel?.font = Constants.backButtonFont
            priceButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var buyButton: UIButton! {
        didSet {
            buyButton.titleLabel?.font = Constants.backButtonFont
            buyButton.isSkeletonable = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showAnimation()
        // Initialization code
    }

    func showAnimation() {
        priceLabel.showSkeleton()
        priceButton.showSkeleton()
        buyButton.showSkeleton()
    }
    
    func removeAnimation() {
        priceLabel.hideSkeleton()
        priceButton.hideSkeleton()
        buyButton.hideSkeleton()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(title: String, price: String, buyButton: String) {
        priceLabel.text = title
        priceLabel.numberOfLines = 0
        priceButton.setTitle(price, for: .normal)
        self.buyButton.setTitle(buyButton, for: .normal)
    }
    
}
