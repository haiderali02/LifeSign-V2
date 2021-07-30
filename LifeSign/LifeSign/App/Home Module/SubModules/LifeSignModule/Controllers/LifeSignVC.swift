//
//  LifeSignVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import AVFoundation
import Starscream

class LifeSignVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            homeTableView.estimatedRowHeight = 250
            homeTableView.rowHeight = UITableView.automaticDimension
            homeTableView.separatorStyle = .none
            
            homeTableView.register(R.nib.healthHomeCell)
            homeTableView.register(R.nib.dailySignHomeCell)
            homeTableView.register(R.nib.sosHomeCell)
            homeTableView.register(R.nib.okSignHomeCell)
        }
    }
    
    // MARK:- PROPERTIES -
    
    var timer: Timer?
    var enableSOSButton: Bool = true
    var soundPlayer: AVAudioPlayer?
    weak var sosCellDelegates: SOSHomeCellProtoCol?
    
    var userDailySignFriends = [Items]()
    
    var userSOSFriendsData: [Items] = [Items]()
    var refreshControl = UIRefreshControl()
    var userCheckFriends: [Items] = [Items]()
    var userTellFriends: [Items] = [Items]()
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        
        // Do any additional setup after loading the view.
    }
    
    var disPatchWaiting: DispatchGroup = DispatchGroup()
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        self.showSpinner(onView: self.view)
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        homeTableView.addSubview(refreshControl)
        
        self.refresh(self.refreshControl)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        disPatchWaiting.enter()
        self.getUserDailySignFriends(searcString: nil)
        disPatchWaiting.enter()
        self.getUserSOSFriends(searcString: nil)
        disPatchWaiting.enter()
        self.getUserOKSignFriends(searchString: nil)
        
        disPatchWaiting.notify(queue: .main) {
            self.homeTableView.reloadData()
            self.removeSpinner()
            print("All Request Done :=- PULL TO REFRESH")
        }
        
    }
    
    @objc func setText() {
        self.homeTableView.reloadData()
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeScreen), name: .refreshHomeScreen, object: nil)
    }
    
    @objc func refreshHomeScreen() {
        print("Refresh 88888*****")
        disPatchWaiting.enter()
        self.getUserDailySignFriends(searcString: nil)
        disPatchWaiting.enter()
        self.getUserOKSignFriends(searchString: nil)
        disPatchWaiting.enter()
        self.getUserSOSFriends(searcString: nil)
        disPatchWaiting.notify(queue: .main) {
            self.homeTableView.reloadData()
            print("All Request Done :=- REFRESH HOME")
        }
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
    
}

extension LifeSignVC: ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.configureDailySign(tableView: tableView, forIndexPath: indexPath)
        } else if indexPath.row == 1 {
            // Return Watch Cell
            return UITableViewCell()
            // return self.configureHealthCell(tableView: tableView, forIndexPath: indexPath)
        } else if indexPath.row == 2 {
            return self.configureSOSCell(tableView: tableView, forIndexPath: indexPath)
        } else if indexPath.row == 3 {
            return self.configureOKCell(tableView: tableView, forIndexPath: indexPath)
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // DailySign VIEW HEIGT = 400
        if indexPath.row == 0 {
            return 395
        }
        // HEALTH CELL
        else if indexPath.row == 1 {
            return 0 //550
        }
        // SOS VIEW HEIGHT = 590
        
        else if indexPath.row == 2 {
            return 590
        }
        // OK SIGN VIEW HEIGT = 738 + 25
        else if indexPath.row == 3 {
            return 738 + 25
        } else {
            return 0
        }
    }
}

