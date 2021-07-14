//
//  HealthPermisionVC.swift
//  LifeSign
//
//  Created by Haider Ali on 14/07/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class HealthPermisionVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var chkBoxHeart: UIButton!
    @IBOutlet weak var chkBoxStep: UIButton!
    @IBOutlet weak var chkBoxCalories: UIButton!
    @IBOutlet weak var chkBoxSleep: UIButton!
    
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    
    // MARK:- PROPERTIES -
    
    
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
      
        
        
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapDone(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapChkBoxHealth(_ sender: UIButton) {
        self.chkBoxHeart.isSelected = !self.chkBoxHeart.isSelected
    }
    
    @IBAction func didTapChkBoxSleep(_ sender: UIButton) {
        self.chkBoxSleep.isSelected = !self.chkBoxSleep.isSelected
    }
    
    @IBAction func didTapCalories(_ sender: UIButton) {
        self.chkBoxCalories.isSelected = !self.chkBoxCalories.isSelected
    }
    @IBAction func didTapSteps(_ sender: UIButton) {
        self.chkBoxStep.isSelected = !self.chkBoxStep.isSelected
    }
}
