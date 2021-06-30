//
//  OkSignInfoVC.swift
//  LifeSign
//
//  Created by Haider Ali on 19/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class OkSignInfoVC: LifeSignBaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = AppStrings.getOkSignTitle()
        }
    }
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.text = AppStrings.getOkSignSubTitle()
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
        
        NotificationCenter.default.post(name: .pageChanged, object: ["pageNumber":0])
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
        subTitleLabel.text = R.string.localizable.sosSubTitle()
        titleLabel.font = Constants.autHeadingFont
        subTitleLabel.font = Constants.bigButtonFont
        
        titleLabel.text = AppStrings.getOkSignTitle()
        subTitleLabel.text = AppStrings.getOkSignSubTitle()
        self.tableView.reloadData()
        
        backButton.isHidden = !showBackButton
        
    }
    
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension OkSignInfoVC: ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.walkThrough, for: indexPath)
        switch indexPath.row {
        case 0:
            cell?.descriptionLabel.text = AppStrings.getOkSignDescriptionOne()
        case 1:
            cell?.descriptionLabel.text = AppStrings.getOkSignDescriptionTwo()
        case 2:
            cell?.descriptionLabel.text = AppStrings.getOkSignDescriptionThree()
        case 3:
            cell?.descriptionLabel.text = StringsManager.shared.use_this_functionality_every_1_hour 
        case 4:
            cell?.descriptionLabel.text = StringsManager.shared.send_as_needed_or_ask_okSign ?? "Send as needed or ask for an OkSign, if you want certainly about a friend"
        case 5:
            cell?.descriptionLabel.text = StringsManager.shared.check_if_reached_safe_on_their_dest ?? "Check if they reached safe on their destination"
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
