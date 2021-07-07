//
//  LanguagesVC.swift
//  LifeSign
//
//  Created by Haider Ali on 16/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS




class LanguagesVC: LifeSignBaseVC {

    // MARK:- OUTLETS -
    
    @IBOutlet weak var selectLangLabel: UILabel! {
        didSet {
            selectLangLabel.font = R.font.robotoMedium(size: 18)
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(R.nib.flagCell)
        }
    }
    @IBOutlet weak var btnCancel: UIButton!
    
    var selectedIndex: IndexPath? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var totalLanguages: [Any] = [Any]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var languageMode: LanguageMode = {
        let mode = LanguageMode.fromSplash
        return mode
    }()
    
    let languagesData = [
        ["name": "English", "flag": R.image.ic_english() ?? UIImage()],
        ["name": "Dansk", "flag": R.image.ic_danish() ?? UIImage()],
        ["name": "اردو", "flag": R.image.ic_pakistan() ?? UIImage()],
        ["name": "العربی", "flag": R.image.ic_arabic() ?? UIImage()],
    ]
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setText()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLanguages()
    }
    
    private func setupView() {
        btnCancel.isHidden = languageMode == .fromSplash
        selectLangLabel.font = Constants.headerSubTitleFont
    }
    
    @objc func setText() {
        selectLangLabel.text = AppStrings.getLanguageTitle()
    }
    
    func getLanguages() {
        AuthManager.getAllLanguages() { response in
            
            switch response.result {
            case .success(let data):
                guard let apiResp = data as? [String: Any],
                      let data = apiResp["data"] as? [Any]
                else {return}
                self.totalLanguages = data
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
            }
        }
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension LanguagesVC: CollectionViewMethods {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalLanguages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.flagCell, for: indexPath)
        
        if let langData = LangObjectModel(JSON: totalLanguages[indexPath.row] as! [String: Any]) {
            cell?.flagName.text = langData.name
            cell?.flagImageView.kf.indicatorType = .activity
            
            switch langData.symbol {
            case "en":
                cell?.flagImageView.image = R.image.ic_english()
            case "da":
                cell?.flagImageView.image = R.image.ic_danish()
            case "ar":
                cell?.flagImageView.image = R.image.ic_arabic()
                if let url = URL(string: langData.image_circle ) {
                    cell?.flagImageView.kf.setImage(with: url)
                }
            case "ur":
                cell?.flagImageView.image = R.image.ic_pakistan()
            default:
                if let url = URL(string: langData.image_circle ) {
                    cell?.flagImageView.kf.setImage(with: url)
                }
            }
            
        }
        
        cell?.higlightedView.isHidden = self
            .selectedIndex != indexPath
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        if let langData = LangObjectModel(JSON: totalLanguages[indexPath.row] as! [String: Any]) {
            self.showSpinner(onView: self.view)
            
            LangObjectModel.shared.saveLanguage(languages: langData)
           
            AuthManager.getLanguageForCountry(symbol: langData.symbol ) { response in
                self.removeSpinner()
                switch response.result {
                case .success(let data):
                    
                    guard let response = data as? [String: Any],
                          let langData = response["data"] as? [String: Any],
                          let langModel = StringsManager(JSON: langData)
                    else {return}
                    StringsManager.shared.deleteStrings()
                    StringsManager.shared.saveStrings(strings: langModel)
                    
                    
                    
                    if self.languageMode != .fromSplash {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: .languageCanged, object: nil)
                        }
                    } else {
                        let authControllers = R.storyboard.authentication.welcomeVC() ?? WelcomeVC()
                        authControllers.showBackButton = true
                        self.push(controller: authControllers, animated: true)
                    }
                case .failure(let err):
                    print("Error: \(err.localizedDescription)")
                }
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = self.collectionView.frame.size
        return CGSize(width: size.width / 2, height: 160)
    }
}
