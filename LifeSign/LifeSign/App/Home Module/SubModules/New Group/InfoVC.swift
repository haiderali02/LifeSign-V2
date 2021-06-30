//
//  InfoVC.swift
//  LifeSign
//
//  Created by Haider Ali on 27/05/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit


protocol InfoItemDelegates: AnyObject
{
    func didSelectItem(at index: Int, and mode: InfoModes)
}

class InfoCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.labelFont
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(name: String, imageColor: UIColor, showImage: Bool, image: UIImage) {
        self.imgView?.backgroundColor = imageColor
        self.titleLabel.text = name
        self.imgView.image = showImage ? image : nil
    }
    
}



class InfoVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = Constants.headerTitleFont
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 80
            tableView.allowsSelection = true
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var btnOk: UIButton! {
        didSet {
            btnOk.titleLabel?.font = Constants.labelFont
        }
    }
    @IBOutlet weak var btnFunctions: UIButton! {
        didSet {
            btnFunctions.titleLabel?.font = Constants.labelFont
        }
    }
    
    let friendsInfo: [[String: Any]] = [
        [
            "name": AppStrings.getYourFriendsString(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name": AppStrings.shareLifeSignOnSocialString(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name":  AppStrings.addPhoneBookString(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name":  AppStrings.addUnknownString(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        
    ]
    
    let sosInfoData: [[String: Any]] = [
        [
            "name": AppStrings.sosPushForThreeSec(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_sos_normal") ?? UIImage()
        ],
        [
            "name": AppStrings.sosSendTab(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name":  AppStrings.sosReceiveTab(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name":  "\(UserManager.shared.userResources?.total_sms ?? 0) " + AppStrings.sosAvailableSMS(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_message") ?? UIImage()
        ],
        [
            "name": AppStrings.sosAddSOSNumber(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_sos_home") ?? UIImage()
        ],
    ]
    
    let dailySignInfoData: [[String: Any]] = [
        [
            "name": AppStrings.dailySignRedColor(),
            "color": UIColor.red,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name": AppStrings.dailySignGreenColor(),
            "color": UIColor.appGreenColor,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name":  AppStrings.dailySignYellowColor(),
            "color": UIColor.appYellowColor,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name":  AppStrings.dailySignOrangeColor(),
            "color": R.color.appOrangeColor() ?? UIColor.systemOrange,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name": AppStrings.dailySignAddFriend(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_addPokeGame") ?? UIImage()
        ],
    ]
    
    let gamePointInfo: [[String: Any]] = [
        [
            "name": AppStrings.one_point_to_start_game(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name": AppStrings.three_point_to_start_game(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name":  AppStrings.ten_point_to_start_game(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        
        
    ]
    
    let gamesInfoData: [[String: Any]] = [
        
        
        [
            "name": AppStrings.gameRedColor(),
            "color": UIColor.red,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name": AppStrings.gameGreenColor(),
            "color": UIColor.appGreenColor,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name":  AppStrings.gameYellowColor(),
            "color": UIColor.appYellowColor,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name":  AppStrings.gameOrangeColor(),
            "color": R.color.appOrangeColor() ?? UIColor.systemOrange,
            "image": UIImage(named: "") ?? UIImage()
        ],
        [
            "name": AppStrings.gameAddPokeGameFriend(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_addPokeGame") ?? UIImage()
        ],
        [
            "name": AppStrings.one_point_to_start_game(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name": AppStrings.three_point_to_start_game(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
        [
            "name":  AppStrings.ten_point_to_start_game(),
            "color": UIColor.clear,
            "image": UIImage(named: "ic_hand") ?? UIImage()
        ],
    ]
    
    // MARK:- PROPERTIES -
    
    weak var delegates: InfoItemDelegates?
    
    var modes: InfoModes = {
        let mode: InfoModes = .dailySignInfo
        return mode
    }()
    
    
    var dataArray: [[String: Any]] = [[String: Any]]()
    
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
        
        switch modes {
        case .dailySignInfo:
            configureDailySignScreenInfo()
        case .sosInfo:
            configureSOSScreenInfo()
        case .friendsInfo:
            configureFriendScreenInfo()
        case .gameInfo:
            configureGameScreenInfo()
        case .hitListInfo:
            configureHitListScreen()
        default:
            return
        }
        
    }
    
    func configureGameScreenInfo() {
        self.titleLabel.text = AppStrings.pokeGameInfo()
        self.dataArray = self.gamesInfoData
        self.tableView.reloadData()
    }
    
    func configureHitListScreen() {
        self.titleLabel.text = AppStrings.getEarnedBadge()
        self.btnFunctions.isHidden = true
        self.dataArray = self.gamePointInfo
        self.tableView.reloadData()
    }
    
    func configureDailySignScreenInfo() {
        self.titleLabel.text = AppStrings.DailySignInfo()
        self.dataArray = self.dailySignInfoData
        self.tableView.reloadData()
    }
    
    func configureSOSScreenInfo() {
        self.titleLabel.text = AppStrings.sosInfo()
        self.dataArray = self.sosInfoData
        self.tableView.reloadData()
    }
    
    func configureFriendScreenInfo() {
        self.titleLabel.text = AppStrings.friendsInfo()
        self.dataArray = self.friendsInfo
        self.tableView.reloadData()
    }
    
    @objc func setText() {
        btnOk.setTitle(AppStrings.getOKButtonString(), for: .normal)
        btnFunctions.setTitle(AppStrings.howToUserFunctions(), for: .normal)
        self.setUI()
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapOk(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func didTapFunctions(_ sender: UIButton) {
        sender.showAnimation {
            switch self.modes {
            case .dailySignInfo:
                if let dailySignInfo = R.storyboard.walkThrough.dailySignInfoVC() {
                    dailySignInfo.showBackButton = true
                    self.present(dailySignInfo, animated: true, completion: nil)
                }
            case .sosInfo:
                if let sosInfo = R.storyboard.walkThrough.sosInfoVC() {
                    sosInfo.showBackButton = true
                    self.present(sosInfo, animated: true, completion: nil)
                }
            case .friendsInfo:
                if let friendInfo = R.storyboard.walkThrough.friendInfoVC() {
                    friendInfo.showBackButton = true
                    self.present(friendInfo, animated: true, completion: nil)
                }
            case .gameInfo:
                if let gameInfo = R.storyboard.walkThrough.gameInfoVC() {
                    gameInfo.showBackButton = true
                    self.present(gameInfo, animated: true, completion: nil)
                }
            
            default:
                return
            }
        }
    }
    
    
    @IBAction func didTapBack(_ sender: UIButton) {
        sender.showAnimation {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension InfoVC: ListViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
        let obj = dataArray[indexPath.row]
        
        if let name = obj["name"] as? String, let color = obj["color"] as? UIColor, let image = obj["image"] as? UIImage {
            if color == UIColor.clear {
                cell.configureCell(name: name, imageColor: color, showImage: true, image: image)
            } else {
                cell.configureCell(name: name, imageColor: color, showImage: false, image: image)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegates?.didSelectItem(at: indexPath.row, and: self.modes)
        }
    }
    
}
