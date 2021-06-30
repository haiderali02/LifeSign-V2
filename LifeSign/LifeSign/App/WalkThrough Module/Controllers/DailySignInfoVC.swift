//
//  DailySignInfoVC.swift
//  LifeSign
//
//  Created by Haider Ali on 15/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit


class DailySignInfoVC: LifeSignBaseVC {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = AppStrings.getDailySignTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = AppStrings.getDailySignSubTitle()
        }
    }
    @IBOutlet weak var backButton: UIButton!
    
    var showBackButton: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setText()
        observeLanguageChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .pageChanged, object: ["pageNumber":2])
    }
    
    // MARK:- FUNCTIONS -
    
    private func registerCell() {
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(R.nib.walkthroughCell)
        
        titleLabel.textColor = R.color.appLightFontColor()
        subTitleLabel.textColor = R.color.appLightFontColor()
        
    }
    
    
    @objc func setText() {
        titleLabel.text = AppStrings.getDailySignTitle()
        subTitleLabel.text = AppStrings.getDailySignSubTitle()
        
        titleLabel.font = Constants.autHeadingFont
        subTitleLabel.font = Constants.headerSubTitleFont
        
        titleLabel.font = Constants.autHeadingFont
        subTitleLabel.font = Constants.bigButtonFont
        
        self.tableView.reloadData()
        backButton.isHidden = !showBackButton
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
}

extension DailySignInfoVC: ListViewMethods {
    
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
            cell?.descriptionLabel.text = AppStrings.getDailySignDescriptionOne()
        case 1:
            cell?.descriptionLabel.text = AppStrings.getDailySignDescriptionTwo()
        case 2:
            cell?.descriptionLabel.text = AppStrings.getDailySignDescriptionThree()
        case 3:
            cell?.descriptionLabel.text = AppStrings.getDailySignDescriptionFour()
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

