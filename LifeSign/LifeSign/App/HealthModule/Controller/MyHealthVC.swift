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
    
    @IBOutlet weak var chartBackView: UIView!
    @IBOutlet weak var restingHeartBackView: UIView!
    @IBOutlet weak var heartRateBackView: UIView!
    @IBOutlet weak var restingHeartImage: UIImageView!
    @IBOutlet weak var RestingHeartLbl: UILabel!
    @IBOutlet weak var restingHeartRateLbl: UILabel!
    @IBOutlet weak var maxHeartView: UIView!
    @IBOutlet weak var maxHeartRateLbl: UILabel!
    @IBOutlet weak var maxHeartLbl: UILabel!
    @IBOutlet weak var minHeartView: UIView!
    @IBOutlet weak var minHeartRateLbl: UILabel!
    @IBOutlet weak var minHeartLbl: UILabel!
    @IBOutlet weak var averageHeartView: UIView!
    @IBOutlet weak var averageHeartRateLbl: UILabel!
    @IBOutlet weak var averageHeartLbl: UILabel!
    
    @IBOutlet weak var sleepBackView: UIView!
    @IBOutlet weak var asleepLbl: UILabel!
    @IBOutlet weak var asleepTimeLbl: UILabel!
    @IBOutlet weak var deepLbl: UILabel!
    @IBOutlet weak var deepTimeLbl: UILabel!
    @IBOutlet weak var lightLbl: UILabel!
    @IBOutlet weak var lightTimeLbl: UILabel!
    @IBOutlet weak var awakeLbl: UILabel!
    @IBOutlet weak var awakeTimeLbl: UILabel!
    
    @IBOutlet weak var stepsDistanceBackView: UIView!
    @IBOutlet weak var stepsActivityBackView: UIView!
    @IBOutlet weak var stepDistanceLbl: UILabel!
    @IBOutlet weak var stepDistanceDetailLbl: UILabel!
    @IBOutlet weak var todayActivityLbl: UILabel!
    @IBOutlet weak var activityWalkingLbl: UILabel!
    @IBOutlet weak var activitytimeLbl: UILabel!
    @IBOutlet weak var activityStepsLbl: UILabel!
    @IBOutlet weak var activityDistanceLbl: UILabel!
    @IBOutlet weak var activityCalorieLbl: UILabel!
    
    @IBOutlet weak var caloriBackView: UIView!
    @IBOutlet weak var calorieBurnLbl: UILabel!
    @IBOutlet weak var calorieBurnDetailLbl: UILabel!
    
    @IBOutlet weak var chartImage: UIImageView!
    
    //MARK:- PROPERTIES -
    
    
    //MARK:- LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        heartBtn.isSelected = true
        chartBackView.isHidden = false
        restingHeartBackView.isHidden = false
        heartRateBackView.isHidden = false
        sleepBackView.isHidden = true
        stepsDistanceBackView.isHidden = true
        stepsActivityBackView.isHidden = true
        caloriBackView.isHidden = true
        chartImage.image = R.image.chart_one()
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
        settingUpHealthBtn(sender.tag)
    }
    
    
}

extension MyHealthVC{
    
    fileprivate func settingUpHealthBtn(_ tag:Int) {
        if tag == 0{
            // Heart Btn Selected..
            heartBtn.isSelected = true
            sleepBtn.isSelected = false
            stepsBtn.isSelected = false
            calorieBtn.isSelected = false
            
            chartImage.image = R.image.chart_one()
            
            heartBtn.backgroundColor = R.color.appGreenColor()
            heartRateLbl.textColor = R.color.appGreenColor()
            sleepBtn.backgroundColor = R.color.appYellowColor()
            sleepLbl.textColor = R.color.appYellowColor()
            stepsBtn.backgroundColor = R.color.appYellowColor()
            stepsLbl.textColor = R.color.appYellowColor()
            calorieBtn.backgroundColor = R.color.appYellowColor()
            calorieLbl.textColor = R.color.appYellowColor()
            
            print("Did Tap Heart Btn")
            
            chartBackView.isHidden = false
            restingHeartBackView.isHidden = false
            heartRateBackView.isHidden = false
            sleepBackView.isHidden = true
            stepsDistanceBackView.isHidden = true
            stepsActivityBackView.isHidden = true
            caloriBackView.isHidden = true
            
            
        }else if tag == 1{
            // Sleep Btn Selected..
            heartBtn.isSelected = false
            sleepBtn.isSelected = true
            stepsBtn.isSelected = false
            calorieBtn.isSelected = false
            
            chartImage.image = R.image.chart_two()
            
            heartBtn.backgroundColor = R.color.appYellowColor()
            heartRateLbl.textColor = R.color.appYellowColor()
            sleepBtn.backgroundColor = R.color.appGreenColor()
            sleepLbl.textColor = R.color.appGreenColor()
            stepsBtn.backgroundColor = R.color.appYellowColor()
            stepsLbl.textColor = R.color.appYellowColor()
            calorieBtn.backgroundColor = R.color.appYellowColor()
            calorieLbl.textColor = R.color.appYellowColor()
            
            print("Did Tap Sleep Btn")
            chartBackView.isHidden = false
            restingHeartBackView.isHidden = true
            heartRateBackView.isHidden = true
            sleepBackView.isHidden = false
            stepsDistanceBackView.isHidden = true
            stepsActivityBackView.isHidden = true
            caloriBackView.isHidden = true
            
            
        }else if tag == 2{
            // Steps Btn Selected..
            heartBtn.isSelected = false
            sleepBtn.isSelected = false
            stepsBtn.isSelected = true
            calorieBtn.isSelected = false
            
            chartImage.image = R.image.chart_three()
            
            heartBtn.backgroundColor = R.color.appYellowColor()
            heartRateLbl.textColor = R.color.appYellowColor()
            sleepBtn.backgroundColor = R.color.appYellowColor()
            sleepLbl.textColor = R.color.appYellowColor()
            stepsBtn.backgroundColor = R.color.appGreenColor()
            stepsLbl.textColor = R.color.appGreenColor()
            calorieBtn.backgroundColor = R.color.appYellowColor()
            calorieLbl.textColor = R.color.appYellowColor()
            
            print("Did Tap Steps Btn")
            chartBackView.isHidden = false
            restingHeartBackView.isHidden = true
            heartRateBackView.isHidden = true
            sleepBackView.isHidden = true
            stepsDistanceBackView.isHidden = false
            stepsActivityBackView.isHidden = false
            caloriBackView.isHidden = true
            
            
            
        }else{
            // Calories Btn Selected..
            heartBtn.isSelected = false
            sleepBtn.isSelected = false
            stepsBtn.isSelected = false
            calorieBtn.isSelected = true
            
            chartImage.image = R.image.chart_four()
            
            heartBtn.backgroundColor = R.color.appYellowColor()
            heartRateLbl.textColor = R.color.appYellowColor()
            sleepBtn.backgroundColor = R.color.appYellowColor()
            sleepLbl.textColor = R.color.appYellowColor()
            stepsBtn.backgroundColor = R.color.appYellowColor()
            stepsLbl.textColor = R.color.appYellowColor()
            calorieBtn.backgroundColor = R.color.appGreenColor()
            calorieLbl.textColor = R.color.appGreenColor()
            
            print("Did Tap Caloies Btn")
            chartBackView.isHidden = false
            restingHeartBackView.isHidden = true
            heartRateBackView.isHidden = true
            sleepBackView.isHidden = true
            stepsDistanceBackView.isHidden = true
            stepsActivityBackView.isHidden = true
            caloriBackView.isHidden = false
            
            
        }
    }
    
    
}
