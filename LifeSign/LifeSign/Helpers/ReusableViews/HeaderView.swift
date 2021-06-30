//
//  HeaderView.swift
//  LifeSign
//
//  Created by Haider Ali on 15/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    var vStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 5.0
        return view
    }()
    
    var userImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = view.frame.height * 0.5
        view.image = nil
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var subscribedImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = view.frame.height * 0.5
        view.image = UIImage(named: "subscribed")
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.text = "Title label"
        label.textAlignment = .left
        label.textColor = R.color.appLightFontColor()
        return label
    }()
    var onlineImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.onlineStatus()
        return view
    }()
    var subTitleLAbel: UILabel = {
        let label = UILabel()
        label.font = Constants.paragraphFont
        label.text = "subTitle label"
        label.textAlignment = .left
        label.textColor = R.color.appLightFontColor()
        return label
    }()
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFontBold
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureViews()
        setupConstrints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        addSubview(vStackView)
        addSubview(userImageView)
        addSubview(onlineImageView)
        addSubview(subscribedImageView)
        userImageView.addSubview(namePrefixLabel)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(subTitleLAbel)
    }

    func configureViews() {
        self.backgroundColor = .clear
        userImageView.layer.cornerRadius = 19
        userImageView.backgroundColor = UIColor.appYellowColor
        userImageView.bringSubviewToFront(onlineImageView)
    }
    func setupConstrints() {
        
        userImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(38)
            make.bottom.equalToSuperview()
            make.leading.top.equalToSuperview()
        }
        onlineImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(12)
            make.trailing.equalTo(userImageView.snp.trailing)
            make.bottom.equalTo(userImageView.snp.bottom)
        }
        namePrefixLabel.snp.makeConstraints { make in
            make.edges.equalTo(userImageView)
        }
        
        vStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(userImageView.snp.trailing).offset(12)
            make.trailing.top.bottom.equalToSuperview()
        }
        subscribedImageView.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.leading.equalTo(vStackView.snp.trailing).offset(8)
            make.top.equalTo(titleLabel.snp.top)
        }
    }
}
