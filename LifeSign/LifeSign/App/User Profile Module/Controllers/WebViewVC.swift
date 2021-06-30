//
//  WebViewVC.swift
//  LifeSign
//
//  Created by Haider Ali on 09/04/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import WebKit

class WebViewVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.titleLabel?.font = Constants.backButtonFont
            if LanguageManager.shared.currentLanguage == .ar || LanguageManager.shared.currentLanguage == .ur {
                backBtn.setImage("ic_back".toImage().flipHorizontally(), for: .normal)
            }
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK:- PROPERTIES -
    
    var urlToOpen: String = ""
    
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
        activityIndicator.isHidden = true
        let url = URL(string: urlToOpen)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
    }
    
    @objc func setText() {
        self.backBtn.setTitle(AppStrings.getSettingsTitle(), for: .normal)
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.pop(controller: self)
    }
}

extension WebViewVC: WKNavigationDelegate {
    
    //MARK:- WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
