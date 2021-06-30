//
//  WalkThroughVC.swift
//  LifeSign
//
//  Created by Haider Ali on 10/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit

class WalkThroughVC: LifeSignBaseVC {

    @IBOutlet weak var pageControlls: UIPageControl!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    func setupView() {
        pageControlls.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
        btnNext.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updatePages), name: .pageChanged, object: nil)
    }
    
    @objc func updatePages(notification: Notification) {
        guard let objects = notification.object as? [String: Any], let pageNumber = objects["pageNumber"] as? Int else {return}
        pageControlls.currentPage = pageNumber
        btnNext.isHidden = pageNumber == 4 ? false : true
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapNext(_ sender: UIButton) {
        let langugesVC = R.storyboard.language.languagesVC() ?? LanguagesVC()
        langugesVC.languageMode = .fromSplash
        push(controller: langugesVC, animated: true)
    }
}
