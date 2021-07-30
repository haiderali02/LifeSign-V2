//
//  EditDailySignVC.swift
//  LifeSign
//
//  Created by Haider Ali on 21/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import DateTimePicker

class EditDailySignVC: LifeSignBaseVC, DateTimePickerDelegate {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTimeZoneLabel: UILabel!
    @IBOutlet weak var editNameLabel: UILabel!
    @IBOutlet weak var editTimeLabel: UILabel!
    @IBOutlet weak var swapeContractLabel: UILabel!
    @IBOutlet weak var deleteLifeSignLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var timerEditView: UIView!
    
    // MARK:- PROPERTIES -
    
    var userFreind: Items!
    
    var namePrefixLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.autHeadingFont
        label.textAlignment = .center
        label.textColor = R.color.appBackgroundColor()
        return label
    }()
    
    
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
        cancelButton.titleLabel?.font = Constants.bigButtonFont
        userNameLabel.font = Constants.labelFont
        userTimeZoneLabel.font = Constants.labelFont
        editNameLabel.font = Constants.labelFont
        editTimeLabel.font = Constants.labelFont
        swapeContractLabel.font = Constants.labelFont
        deleteLifeSignLabel.font = Constants.labelFont
        
        userImageView.addSubview(namePrefixLabel)
        
        namePrefixLabel.snp.makeConstraints { make in
            make.edges.equalTo(userImageView)
        }
        
        userNameLabel.text = userFreind.full_name
        userTimeZoneLabel.text = userFreind.timezone
        userImageView.backgroundColor = R.color.appYellowColor()
        userImageView.kf.indicatorType = .activity
        userImageView.kf.setImage(with: URL(string: userFreind.profile_image)) { (result) in
            switch result {
            case .success(_ ):
                // print(data)
                self.namePrefixLabel.isHidden = true
                // let fullName = self.userFreind.first_name + " " + self.userFreind.last_name
                self.namePrefixLabel.text = self.userFreind.full_name
                
                self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                
            case .failure(_ ):
                // print(err.localizedDescription)
                self.namePrefixLabel.isHidden = false
                self.userImageView.image = nil
                // let fullName = self.userFreind.first_name + " " + self.userFreind.last_name
                self.namePrefixLabel.text = self.userFreind.full_name.getPrefix
            }
        }
        
        
        
        timerEditView.isHidden = userFreind.initiator == 0 ? true : false
        
    }
    
    @objc func setText() {
        editNameLabel.text = AppStrings.getEditNickName()
        editTimeLabel.text = AppStrings.getEditLSTime()
        swapeContractLabel.text = AppStrings.getSwapeString()
        deleteLifeSignLabel.text = AppStrings.getRemoveFromLifeSign()
        
        cancelButton.setTitle(AppStrings.getCancelString(), for: .normal)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        if text.count > 16 {
            textField.text?.removeLast()
        }
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapEditNickName(_ sender: UIButton) {
        let alertController = UIAlertController(title: AppStrings.getEditNickName(), message: nil, preferredStyle: .alert)
        alertController.addTextField { (userNameField) in
            userNameField.placeholder = AppStrings.getSignupFullNameTitle()
            userNameField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
            userNameField.text = self.userFreind.full_name
        }
        alertController.addAction(UIAlertAction(title: AppStrings.getSaveButton(), style: .default, handler: { (_ ) in
            // Save Action
            
            if let field = alertController.textFields?[0] {
                
                guard let userNickName = field.text else {return}
                print("User New Name Sould be: \(userNickName)")
                self.showSpinner(onView: self.view)
                LifeSignManager.updateNickName(nickName: userNickName, dailySignID: "\(self.userFreind.daily_sign_id)") { status, errors in
                    self.removeSpinner()
                    if errors == nil {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                        }
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: AppStrings.getCancelString(), style: .cancel, handler: { (_ ) in
            // Cancel Action
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapEditLifeSignTime(_ sender: UIButton) {
        var min = Date()
        
        min = Date().addingTimeInterval(60 * 60 * 24 * (-1))
        let max = Date().addingTimeInterval(60 * 60 * 24 * 1)
        let picker = DateTimePicker.create(minimumDate: min, maximumDate: max)
        
     
        picker.dateFormat = "HH:mm"
        picker.includesSecond = true
        picker.highlightColor = UIColor.appBoxColor
        picker.doneButtonTitle = AppStrings.getDoneString()
        picker.isTimePickerOnly = true
        picker.doneBackgroundColor = UIColor.appBoxColor
        picker.customFontSetting = DateTimePicker.CustomFontSetting(selectedDateLabelFont: Constants.bigButtonFont)
        picker.completionHandler = { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            LifeSignManager.updateDailySignTime(dailySignID: "\(self.userFreind.daily_sign_id)", signTime: picker.selectedDateString) { status, errors in
                if errors == nil {
                    NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
        }
        picker.delegate = self
        picker.show()
    }
    
    @IBAction func didTapSwapContract(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        LifeSignManager.swapeDailySign(dailySignID: "\(userFreind.daily_sign_id)") { status, errors in
            self.removeSpinner()
            if errors == nil {
                NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    @IBAction func didTapDeleteLifeSign(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        LifeSignManager.deleteFromDailySign(dailySignID: "\(userFreind.daily_sign_id)") { status, errors in
            self.removeSpinner()
            if errors == nil {
                NotificationCenter.default.post(name: .refreshHomeScreen, object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    @IBAction func didTapCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///
    // MARK:- DATE PICKER DELEGATE -
    ///
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        // print("Picker Time: \(picker.selectedDateString)")
    }
    
}
