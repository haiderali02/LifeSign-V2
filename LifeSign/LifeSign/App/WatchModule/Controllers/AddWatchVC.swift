//
//  AddWatchVC.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class AddWatchVC: LifeSignBaseVC{
    
    //MARK:- OUTLETS -
    @IBOutlet weak var addWatchImage: UIImageView!
    @IBOutlet weak var noDeviceLbl: UILabel!
    @IBOutlet weak var noDeviceDetailLbl: UILabel!
    @IBOutlet weak var addDeviceBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!{
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    
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
        noDeviceLbl.text = "No device added"
        noDeviceDetailLbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut duis tortor orci, vitae, neque sem egestas. Venenatis, at malesuada gravida dui convallis. "
        addDeviceBtn.setTitle("Add Device", for: .normal)
    }
    
    func setUI() {
        noDeviceLbl.font = Constants.headerTitleFont
        noDeviceLbl.textColor = R.color.appYellowColor()
        noDeviceDetailLbl.font = Constants.labelFont
        noDeviceDetailLbl.textColor = .white
        addDeviceBtn.titleLabel?.font = Constants.bigButtonFont
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    //MARK:- ACTIONS -
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapAddDeviceBtn(_ sender: UIButton) {
        sender.showAnimation {
            guard let connectedDeviceVC = R.storyboard.watchBoard.connectedWatchVC() else{
                return
            }
            
            self.navigationController?.pushViewController(connectedDeviceVC, animated: true)
        }
    }
    
    
}
