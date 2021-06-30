//
//  FriendRequestVC.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class FriendRequestVC: LifeSignBaseVC{
    
    //MARK:- OUTLETS -
    
    @IBOutlet weak var freindRequestTableView: UITableView!{
        didSet{
            freindRequestTableView.delegate = self
            freindRequestTableView.dataSource = self
            freindRequestTableView.register(R.nib.friendRequestCell)
        }
    }
    
    //MARK:- PROPERTIES -
    
    let arrayOfNames = ["Sue Bell","Frances Oconnor","Mike Chapman","Billie Gross","Daniel Becker","Earl Oconnor","Marjorie Hall","Manuel Coleman","Leona Little","Debra Schultz","Derrick Day","Scott Johnston"]
    
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
        
    }
    
    func setUI() {
        
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    //MARK:- ACTIONS -
    
    @objc func didTapAcceptBtn(_ sender:UIButton){
        sender.showAnimation {
            
        }
    }
    
    @objc func didTapRejectBtn(_ sender:UIButton){
        sender.showAnimation {
            
        }
    }
    
}

extension FriendRequestVC: ListViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureFriendRequestCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    
}


extension FriendRequestVC{
    
    func configureFriendRequestCell(_ indexPath:IndexPath) -> UITableViewCell{
        let cell = freindRequestTableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
        cell.nameLbl.text = arrayOfNames[indexPath.row]
        cell.profileImage.image = UIImage(named: arrayOfNames[indexPath.row])
        cell.acceptBtn.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(didTapAcceptBtn(_:)), for: .touchUpInside)
        cell.rejectBtn.tag = indexPath.row
        cell.rejectBtn.addTarget(self, action: #selector(didTapRejectBtn(_:)), for: .touchUpInside)
        return cell
    }
    
}
