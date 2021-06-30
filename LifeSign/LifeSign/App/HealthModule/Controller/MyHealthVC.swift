//
//  MyHealthVC.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class MyHealthVC: LifeSignBaseVC{
    
    //MARK:- OUTLETS -
    
    @IBOutlet weak var heartBtn: UIButton!{
        didSet{
            heartBtn.tag = 0
            heartBtn.layer.cornerRadius = heartBtn.frame.height / 2
        }
    }
    @IBOutlet weak var heartRateLbl: UILabel!
    @IBOutlet weak var sleepBtn: UIButton!{
        didSet{
            sleepBtn.tag = 1
            sleepBtn.layer.cornerRadius = sleepBtn.frame.height / 2
        }
    }
    @IBOutlet weak var sleepLbl: UILabel!
    @IBOutlet weak var stepsBtn: UIButton!{
        didSet{
            stepsBtn.tag = 2
            stepsBtn.layer.cornerRadius = stepsBtn.frame.height / 2
        }
    }
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var calorieBtn: UIButton!{
        didSet{
            calorieBtn.tag = 3
            calorieBtn.layer.cornerRadius = calorieBtn.frame.height / 2
        }
    }
    @IBOutlet weak var calorieLbl: UILabel!
    
    
    
    //MARK:- PROPERTIES -
    
    
    //MARK:- LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        heartBtn.isSelected = true
        // Do any additional setup after loading the view.
    }
    
    //MARK:- METHODS -
    @objc func setText(){
        
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    //MARK:- ACTIONS -
    
    @IBAction func didTapHealthBtn(_ sender: UIButton) {
        if sender.tag == 0{
            // Heart Btn Selected..
            heartBtn.isSelected = true
            sleepBtn.isSelected = false
            stepsBtn.isSelected = false
            calorieBtn.isSelected = false
            print("Did Tap Heart Btn")
            
        }else if sender.tag == 1{
            // Sleep Btn Selected..
            heartBtn.isSelected = false
            sleepBtn.isSelected = true
            stepsBtn.isSelected = false
            calorieBtn.isSelected = false
            print("Did Tap Sleep Btn")
        }else if sender.tag == 2{
            // Steps Btn Selected..
            heartBtn.isSelected = false
            sleepBtn.isSelected = false
            stepsBtn.isSelected = true
            calorieBtn.isSelected = false
            print("Did Tap Steps Btn")
        }else{
            // Calories Btn Selected..
            heartBtn.isSelected = false
            sleepBtn.isSelected = false
            stepsBtn.isSelected = false
            calorieBtn.isSelected = true
            print("Did Tap Caloies Btn")
        }
    }
    
    
}
