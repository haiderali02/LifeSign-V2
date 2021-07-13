//
//  SOSListingVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class SOSListingVC: LifeSignBaseVC {

    @IBOutlet weak var sosSentButton: DesignableButton! {
        didSet {
            sosSentButton.titleLabel?.font = Constants.headerTitleFont
        }
    }
    @IBOutlet weak var sosReceivedButton: DesignableButton! {
        didSet {
            sosReceivedButton.titleLabel?.font = Constants.headerTitleFont
        }
    }
    
    @IBOutlet weak var sosListView: UITableView! {
        didSet {
            sosListView.estimatedRowHeight = 80
            sosListView.rowHeight = UITableView.automaticDimension
            sosListView.separatorStyle = .none
            sosListView.backgroundColor = .clear
            sosListView.separatorStyle = .none
            sosListView.register(R.nib.friendsTableViewCell)
        }
    }
    
    // MARK:- PROPERTIES -
    var refreshControl = UIRefreshControl()
    var sosReceived: [SOSListObject] = [SOSListObject]()
    var sosSent: [SOSListObject] = [SOSListObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setText()
        observerLanguageChange()
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func setupUI() {
        self.didTapSOSSent(self.sosSentButton)
        refreshControl.attributedTitle = nil
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        sosListView.addSubview(refreshControl)
        
        getSOSListings()
        
    }
    @objc func setText() {
        sosSentButton.setTitle(AppStrings.sosSents(), for: .normal)
        sosReceivedButton.setTitle(AppStrings.sosReceived(), for: .normal)
        self.sosListView.emptyDataSetView { (dataSet) in
            dataSet.detailLabelString(NSAttributedString(string: AppStrings.getNoDatFoundString()))
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.getSOSListings()
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    func handleButtonTappedStats() {
        if sosSentButton.isSelected {
            sosSentButton.backgroundColor = R.color.appYellowColor()
            sosSentButton.setTitleColor(R.color.appBoxesColor(), for: .normal)
            
            sosReceivedButton.backgroundColor = R.color.appBoxesColor()
            sosReceivedButton.setTitleColor(R.color.appLightFontColor(), for: .normal)
            
            // GET SOS SENTS
        } else {
            sosReceivedButton.backgroundColor = R.color.appYellowColor()
            sosReceivedButton.setTitleColor(R.color.appBoxesColor(), for: .normal)
            
            sosSentButton.backgroundColor = R.color.appBoxesColor()
            sosSentButton.setTitleColor(R.color.appLightFontColor(), for: .normal)
        }
        self.sosListView.reloadData()
    }
    
    fileprivate func getSOSListings() {
        self.showSpinner(onView: self.view)
        SOSManager.getSOSListing(searchString: nil, limit: nil, PageNumber: nil) { (sosData, errors, links) in
            self.refreshControl.endRefreshing()
            self.removeSpinner()
            self.sosSent.removeAll()
            self.sosReceived.removeAll()
            if errors == nil {
                if let sosListing = sosData?.sos_listing {
                    
                    for sos in sosListing {
                        
                        if sos.sos_sender == true {
                            
                            self.sosSent.append(sos)
                            
                        } else {
                            
                            self.sosReceived.append(sos)
                            
                        }
                        
                    }
                    self.sosListView.reloadData()
                }
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapSOSSent(_ sender: UIButton) {
        self.sosSentButton.isSelected = true
        self.sosReceivedButton.isSelected = false
        self.handleButtonTappedStats()
    }
    @IBAction func didTapSOSReceived(_ sender: UIButton) {
        self.sosReceivedButton.isSelected = true
        self.sosSentButton.isSelected = false
        self.handleButtonTappedStats()
    }
    
    @objc func didTapCellButton(_ sender: UIButton) {
        if self.sosReceivedButton.isSelected {
            // Perform GOT IT Action
            print("Got IT: \(sender.tag)")
            let sosObj = sosReceived[sender.tag]
            if !sosObj.sos_read {
                SOSManager.markSOSSeen(sosID: "\(sosObj.sos_id)") { (status, errors) in
                    if errors == nil {
                        self.getSOSListings()
                    } else {
                        ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                    }
                }
            }
        } else {
            // Do Nothing
        }
    }
    
}

extension SOSListingVC : ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sosSentButton.isSelected ? self.sosSent.count : sosReceived.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.friendsTableViewCell, for: indexPath)
        
        cell?.trailingButton.tag = indexPath.row
        
        let sosObj = self.sosSentButton.isSelected ? sosSent[indexPath.row] : sosReceived[indexPath.row]
        cell?.emptyCell()
        cell?.providerImage.image = nil
        cell?.removeAnimation()
        if sosObj.provider == .app {
            cell?.providerImage.image = nil
        } else if sosObj.provider == .facebook {
            cell?.providerImage.image = R.image.ic_facebook_headd()
        } else if sosObj.provider == .apple {
            cell?.providerImage.image = R.image.ic_apple_head()
        }
        
        cell?.configureCell(withTitle: sosObj.first_name + " " + sosObj.last_name, subTitle: sosObj.sos_send_datetime, userImage: sosObj.profile_image, type: .sosListing)
        
        cell?.trailingButton.addTarget(self, action: #selector(self.didTapCellButton(_:)), for: .touchUpInside)
        cell?.trailingButton.isHidden = false
        
        cell?.trailingButton.setTitle(self.sosSentButton.isSelected ? AppStrings.sosUnSeen() : AppStrings.sosGotIT(), for: .normal)
        
        
        if sosObj.sos_read {
            cell?.trailingButton.setTitle(AppStrings.sosMarkedSeen(), for: .normal)
            cell?.trailingButton.setTitleColor(R.color.appGreenColor(), for: .normal)
        } else {
            cell?.trailingButton.setTitleColor(self.sosSentButton.isSelected ? R.color.appRedColor() : R.color.appGreenColor(), for: .normal)
        }
        
        return cell ?? FriendsTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
