//
//  FriendHealthVC.swift
//  LifeSign
//
//  Created by APPLE on 6/29/21.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class FriendHealthVC: LifeSignBaseVC{
    
    //MARK:- OUTLETS -
    @IBOutlet weak var friendHealthCollectionView: UICollectionView!{
        didSet{
            friendHealthCollectionView.delegate = self
            friendHealthCollectionView.dataSource = self
            friendHealthCollectionView.register(R.nib.friendHealthCell)
        }
    }
    
    //MARK:- PROPERTIES -
    let arrayOfNames = ["Sue Bell","Frances Oconnor","Mike Chapman","Billie Gross","Daniel Becker","Earl Oconnor","Marjorie Hall","Manuel Coleman","Leona Little","Debra Schultz","Derrick Day","Scott Johnston"]
    
    var userHealthFriends: [Items] = [Items]()
    
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
    
    fileprivate func getUserHealthFriends() {
        self.showSpinner(onView: self.view)
        FriendManager.getUserHealthFriends(type: .accepted, limit: 50, PageNumber: 1) { friendsData, errors, links in
            self.removeSpinner()
            if errors == nil {
                guard let friendData = friendsData,
                      let friends = friendData.items
                else {return}
                
                self.userHealthFriends = friends
                
                self.friendHealthCollectionView.reloadData()
                
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    func setUI() {
        getUserHealthFriends()
    }
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    
    //MARK:- ACTIONS -
    
    
    
}

extension FriendHealthVC: CollectionViewMethods{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userHealthFriends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureFriendHealthCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 3), height: 175)
    }
    

}

extension FriendHealthVC{
    
    func configureFriendHealthCell(_ indexPath:IndexPath) -> UICollectionViewCell{
        let cell = friendHealthCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendHealthCell", for: indexPath) as! FriendHealthCell
        
        let userFriend = self.userHealthFriends[indexPath.row]
        
        cell.configureCell(userImage: userFriend.profile_image, userName: userFriend.full_name, healthColor: "#e3e3bb")
        return cell
    }
    
}
