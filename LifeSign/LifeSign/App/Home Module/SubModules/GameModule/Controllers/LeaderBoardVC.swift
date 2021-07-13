//
//  LeaderBoardVC.swift
//  LifeSign
//
//  Created by Haider Ali on 02/06/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class LeaderBoardVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPositionLabel: UILabel!
    @IBOutlet weak var positionTitleLabel: UILabel!
    
    var myPosition: Int = 0
    
    @IBOutlet weak var leaderBoardTableView: UITableView! {
        didSet {
            leaderBoardTableView.delegate = self
            leaderBoardTableView.dataSource = self
            leaderBoardTableView.estimatedRowHeight = 60.0
            leaderBoardTableView.rowHeight = UITableView.automaticDimension
            leaderBoardTableView.register(R.nib.leaderBoardCell)
            leaderBoardTableView.showsVerticalScrollIndicator = false
        }
    }
    
    // MARK:- PROPERTIES -
    let sectionHeaderLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = Constants.headerTitleFont
        return label
    }()
    
    var top100Users: [Any] = [Any]()
    var myFriends: [Any] = [Any]()
    var isFetching: Bool = false {
        didSet {
            leaderBoardTableView.reloadData()
        }
    }
    
    var headerView: UIView = UIView()
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
        positionTitleLabel.isHidden = true
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: leaderBoardTableView.frame.width, height: 80))
        headerView.backgroundColor = R.color.appSeperatorColor()
        headerView.addSubview(sectionHeaderLabel)
        sectionHeaderLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        userImageView.addSubview(namePrefixLabel)
        namePrefixLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(userImageView)
        }
        
        // userImageView.image = Constants.getCurrentUserImage()
        if UserManager.shared.profil_Image != "" {
            userImageView.kf.indicatorType = .activity
            userImageView.kf.setImage(with: URL(string: UserManager.shared.profil_Image)) { (result) in
                switch result {
                case .success(_ ):
                    // print(data)
                    self.namePrefixLabel.isHidden = true
                    self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                    self.userImageView.setupImageViewer(options: [.closeIcon(R.image.ic_cross() ?? UIImage()), .theme(.dark)], from: nil)
                case .failure(_ ):
                    // print(err.localizedDescription)
                    self.namePrefixLabel.isHidden = false
                    self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
                }
            }
        } else {
            self.namePrefixLabel.isHidden = false
            self.userImageView.image = nil
            self.namePrefixLabel.text = UserManager.shared.getUserFullName().getPrefix
        }
        
        
        userNameLabel.text = UserManager.shared.getUserFullName()
        userPositionLabel.text = "\(myPosition)"
        getLeaderBoardData()
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getLeaderBoardString(), for: .normal)
    }
    
    
    func getLeaderBoardData() {
        
        isFetching = true
        
        GameManager.getLeaderBoaed { top100Users, myFriends, errors, links in
            
            self.isFetching = false
            
            if errors == nil {
                if let wordWideTop = top100Users {
                    self.top100Users = wordWideTop
                }
                if let myFriends = myFriends {
                    self.myFriends = myFriends
                }
                self.leaderBoardTableView.reloadData()
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
        
    }
    
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    func showInfoScreen(modes: InfoModes) {
        if let controller = R.storyboard.home.infoVC() {
            controller.modes = modes
            // controller.delegates = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK:- ACTIONS -
    
    
    @IBAction func didTapInfo(_ sender: UIButton) {
        sender.showAnimation {
            self.showInfoScreen(modes: .hitListInfo)
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
}

extension LeaderBoardVC: ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isFetching ? 5 : self.top100Users.count
        } else {
            return isFetching ? 5 : self.myFriends.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.leaderBoardCell, for: indexPath)
        if isFetching {
            cell?.showAnimation()
            return cell ?? UITableViewCell()
        } else {
            cell?.hideAnimation()
            
            if indexPath.section == 0 {
                
                let userObj = Items(JSON: top100Users[indexPath.row] as! [String: Any])
                if let userID = userObj?.user_id {
                    if userID == UserManager.shared.user_id {
                        self.myPosition = userObj?.position ?? 0
                        self.userPositionLabel.text = "\(self.myPosition)"
                    }
                }
                cell?.configureCell(indexNumber: userObj?.position ?? 0, userImgUrl: userObj?.profile_image ?? "", userName: userObj?.full_name ?? "", userPostion: userObj?.points ?? 0)
                
            } else {
                
                let userObj = Items(JSON: myFriends[indexPath.row] as! [String: Any])
                
                cell?.configureCell(indexNumber: userObj?.position ?? 0, userImgUrl: userObj?.profile_image ?? "", userName: userObj?.full_name ?? "", userPostion: userObj?.points ?? 0)
                
            }
            return cell ?? UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.backgroundColor = .red
        header.textLabel?.font = Constants.headerTitleFont
        header.textLabel?.textAlignment = .center
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return AppStrings.getWorldWideTop()
        } else {
            return AppStrings.getMyFriendsString()
        }
    }
}
