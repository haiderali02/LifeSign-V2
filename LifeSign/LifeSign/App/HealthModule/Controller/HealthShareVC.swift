//
//  HealthShareVC.swift
//  LifeSign
//
//  Created by Haider Ali on 01/07/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

protocol HealthShareDelegate: AnyObject {
    func userPermisions(health: Bool, sleep: Bool, steps: Bool, calories: Bool)
}


class HealthShareVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var healthLabel: UILabel! {
        didSet {
            healthLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var healthCheckbox: UIButton! {
        didSet {
            healthCheckbox.setImage(R.image.ic_checked(), for: .selected)
            healthCheckbox.setImage(R.image.ic_unchecked(), for: .normal)
        }
    }
    
    @IBOutlet weak var sleepLabel: UILabel! {
        didSet {
            sleepLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var sleepCheckbox: UIButton! {
        didSet {
            sleepCheckbox.setImage(R.image.ic_checked(), for: .selected)
            sleepCheckbox.setImage(R.image.ic_unchecked(), for: .normal)
        }
    }
    @IBOutlet weak var stepLabel: UILabel! {
        didSet {
            stepLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var stepCheckbox: UIButton! {
        didSet {
            stepCheckbox.setImage(R.image.ic_checked(), for: .selected)
            stepCheckbox.setImage(R.image.ic_unchecked(), for: .normal)
        }
    }
    @IBOutlet weak var caloriesLabel: UILabel! {
        didSet {
            caloriesLabel.font = Constants.labelFont
        }
    }
    @IBOutlet weak var caloriesCheckbox: UIButton! {
        didSet {
            caloriesCheckbox.setImage(R.image.ic_checked(), for: .selected)
            caloriesCheckbox.setImage(R.image.ic_unchecked(), for: .normal)
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.titleLabel?.font = Constants.bigButtonFont
        }
    }
    
    // MARK:- PROPERTIES -
    
    weak var delegates: HealthShareDelegate?
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        
    }
    
    @objc func setText() {
        doneButton.setTitle(AppStrings.getDoneString(), for: .normal)
        healthLabel.text = AppStrings.getHealthString()
        stepLabel.text = AppStrings.getStepsString()
        caloriesLabel.text = AppStrings.getCaloriesString()
        sleepLabel.text = AppStrings.getSleepString()
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapDoneButton(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true) {
                self.delegates?.userPermisions(health: self.healthCheckbox.isSelected, sleep: self.sleepCheckbox.isSelected, steps: self.stepCheckbox.isSelected, calories: self.caloriesCheckbox.isSelected)
            }
        }
    }
    
    @IBAction func didTapHealthCheckbox(_ sender: UIButton) {
        self.healthCheckbox.isSelected = !self.healthCheckbox.isSelected
    }
   
    @IBAction func didTapSleepCheckbox(_ sender: UIButton) {
        self.sleepCheckbox.isSelected = !self.sleepCheckbox.isSelected
    }
    
    @IBAction func didTapStepsCheckbox(_ sender: UIButton) {
        self.stepCheckbox.isSelected = !self.stepCheckbox.isSelected
    }
    
    @IBAction func didTapCaloriesCheckbox(_ sender: UIButton) {
        self.caloriesCheckbox.isSelected = !self.caloriesCheckbox.isSelected
    }
}
