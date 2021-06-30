//
//  FriendInfoVC.swift
//  LifeSign
//
//  Created by Haider Ali on 15/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class FriendInfoVC: LifeSignBaseVC {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 180
            tableView.rowHeight = UITableView.automaticDimension
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.register(R.nib.walkthroughCell)
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = AppStrings.getFriendsTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = AppStrings.getFriendsSubTitle()
        }
    }
    @IBOutlet weak var backButton: UIButton!
    
    var showBackButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setText()
        observerLanguageChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .pageChanged, object: ["pageNumber":3])
    }
    
    // MARK:- FUNCTIONS -
    
    private func setupUI() {
        titleLabel.textColor = R.color.appLightFontColor()
        subTitleLabel.textColor = R.color.appLightFontColor()
    }
    
    @objc func setText() {
        titleLabel.font = Constants.autHeadingFont
        subTitleLabel.font = Constants.headerSubTitleFont
        
        titleLabel.font = Constants.autHeadingFont
        subTitleLabel.font = Constants.bigButtonFont
        
        titleLabel.text = AppStrings.getFriendsTitle()
        subTitleLabel.text = AppStrings.getFriendsSubTitle()
        self.tableView.reloadData()
        
        backButton.isHidden = !showBackButton
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension FriendInfoVC: ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.walkThrough, for: indexPath)
        switch indexPath.row {
        case 0:
            cell?.descriptionLabel.text = AppStrings.getFriendsDescriptionOne()
        case 1:
            cell?.descriptionLabel.text = AppStrings.getFriendsDescriptionTwo()
        case 2:
            cell?.descriptionLabel.text = AppStrings.getFriendsDescriptionThree()
        case 3:
            cell?.descriptionLabel.text = AppStrings.getFriendsDescriptionFour()
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
