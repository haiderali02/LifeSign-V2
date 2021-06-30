//
//  OtherAppsVC.swift
//  LifeSign
//
//  Created by Haider Ali on 23/06/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class OtherAppsVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var downloadAppsLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(R.nib.otherAppCell)
        }
    }
    // MARK:- PROPERTIES -
    
    var otherGames: [OtherGamesModel] = [OtherGamesModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var selectedIndex: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            collectionView.reloadData()
        }
    }
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
        GameManager.getAllOtherApps { otherGame, errors in
            if errors == nil {
                guard let games = otherGame else{ return }
                self.otherGames = games
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
    }
    
    @objc func applicationDidBecomeActive() {
        // handle event
        self.checkIfAppInstalled(self.selectedIndex, shouldOpenApp: false)
    }
    
    @objc func setText() {
        self.downloadAppsLabel.text = AppStrings.getDownloadOurOtherApps()
        self.rewardLabel.text = AppStrings.get1000AutoClicksForFree()
        self.backBtn.setTitle(AppStrings.getBackButtonString(), for: .normal)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
}


extension OtherAppsVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.otherAppCell, for: indexPath)
      
        let gameObject = otherGames[indexPath.row]
        cell?.installedIcon.isHidden = !gameObject.is_reward
        cell?.appName.text = gameObject.app_name
        cell?.appImageView.kf.indicatorType = .activity
        cell?.appImageView.kf.setImage(with: URL(string: gameObject.app_image))
        
        return cell ?? UICollectionViewCell()
    }
    
    fileprivate func checkIfAppInstalled(_ indexPath: IndexPath, shouldOpenApp: Bool) {
        let gameObject = otherGames[self.selectedIndex.row]
        
        if gameObject.is_reward {
            return
        }
        
        let appURL = URL(string: "\(gameObject.ios_scheme)://")!
        let application = UIApplication.shared
        
        
        
        print("Scheme: \(gameObject.ios_scheme)")
        
        if application.canOpenURL(appURL) {
            if shouldOpenApp {
                application.open(appURL)
            } else {
                GameManager.earnReward(rewardType: .downloadApp, app_id: gameObject.app_id) { status, errors in
                    if errors == nil {
                        AlertController.showAlert(witTitle: AppStrings.getCongratsString(), withMessage: AppStrings.getRewardSuccessString(), style: .success, controller: self)
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            }
        } else {
            if shouldOpenApp {
                let gameObject = otherGames[indexPath.row]
                application.open(URL(string: gameObject.app_url)!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath
        
        checkIfAppInstalled(indexPath, shouldOpenApp: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.collectionView.frame.size
        return CGSize(width: size.width / 2, height: 180)
    }
}
