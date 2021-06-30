//
//  PasswordUpdatedVC.swift
//  LifeSign
//
//  Created by Haider Ali on 19/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class PasswordUpdatedVC: LifeSignBaseVC {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var successLabel: UILabel! {
        didSet {
            successLabel.font = Constants.labelFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                successLabel.textAlignment = .right
            }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var doneBtn: UIButton! {
        didSet {
            doneBtn.titleLabel?.font = Constants.bigButtonFont
        }
    }
    
    var didUpDatePassword: ((_ updated: Bool, _ value: Any?) -> Void)?
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setText()
        observeLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI () {
        
    }
    @objc func setText() {
        doneBtn.setTitle(AppStrings.getOKButtonString(), for: .normal)
        successLabel.text = AppStrings.getSuccessUpdateTitle()
    }
    func observeLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    // MARK:- ACTIONS -
    
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.didUpDatePassword?(true, nil)
        }
    }
}
