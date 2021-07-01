//
//  ConnectedWatchVC.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class ConnectedWatchVC: LifeSignBaseVC{
    
    //MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton!{
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceNameLbl: UILabel!
    @IBOutlet weak var heartView: UIView!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var heartLbl: UILabel!
    @IBOutlet weak var heartRateLbl: UILabel!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var sleepImage: UIImageView!
    @IBOutlet weak var sleepLbl: UILabel!
    @IBOutlet weak var sleepTimeLbl: UILabel!
    @IBOutlet weak var stepsView: UIView!
    @IBOutlet weak var stepsImage: UIImageView!
    @IBOutlet weak var stepsLbl: UILabel!
    @IBOutlet weak var stepsCountLbl: UILabel!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var caloriesImage: UIImageView!
    @IBOutlet weak var caloriesLbl: UILabel!
    @IBOutlet weak var caloriesCountLbl: UILabel!
    @IBOutlet weak var disconnectWatchBtn: UIButton!
    
    //MARK:- PROPERTIES -
    
    
    //MARK:- LIFE CYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observers()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- METHODS -
    @objc func setText(){
        deviceNameLbl.text = "H706 - 6271 Connected"
        heartLbl.text = "Heart rate"
        heartRateLbl.text = "120/90"
        sleepLbl.text = "Sleep"
        sleepTimeLbl.text = "7 Hours"
        stepsLbl.text = "Steps"
        stepsCountLbl.text = "235487"
        caloriesLbl.text = "Calories"
        caloriesCountLbl.text = "2145"
        disconnectWatchBtn.setTitle("Want to disconnect watch", for: .normal)
    }
    
    func setUI() {
        deviceNameLbl.font = Constants.headerTitleFont
        deviceNameLbl.textColor = R.color.appYellowColor()
        heartLbl.font = Constants.headerSubTitleFont
        heartLbl.textColor = R.color.appYellowColor()
        heartRateLbl.font = Constants.headerSubTitleFont
        heartRateLbl.textColor = R.color.appYellowColor()
        sleepLbl.font = Constants.headerSubTitleFont
        sleepLbl.textColor = R.color.appYellowColor()
        sleepTimeLbl.font = Constants.headerSubTitleFont
        sleepTimeLbl.textColor = R.color.appYellowColor()
        stepsLbl.font = Constants.headerSubTitleFont
        stepsLbl.textColor = R.color.appYellowColor()
        stepsCountLbl.font = Constants.headerSubTitleFont
        stepsCountLbl.textColor = R.color.appYellowColor()
        caloriesLbl.font = Constants.headerSubTitleFont
        caloriesLbl.textColor = R.color.appYellowColor()
        caloriesCountLbl.font = Constants.headerSubTitleFont
        caloriesCountLbl.textColor = R.color.appYellowColor()
        disconnectWatchBtn.titleLabel?.font = Constants.bigButtonFont
        disconnectWatchBtn.setTitleColor(.white, for: .normal)
        disconnectWatchBtn.backgroundColor = R.color.appRedColor()
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    //MARK:- ACTIONS -
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapDisconnectWatchBtn(_ sender: UIButton) {
        sender.showAnimation {
            
        }
    }
    
}
