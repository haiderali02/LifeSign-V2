//
//  ShopVC.swift
//  LifeSign
//
//  Created by Haider Ali on 24/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import UIKit
import LanguageManager_iOS
import StoreKit
import SkeletonView
import UnityAds

class ShopVC: LifeSignBaseVC {
    
    // MARK:- OUTLETS -
    
    @IBOutlet weak var lifeSignButton: UIButton! {
        didSet {
            lifeSignButton.setImage(R.image.ic_ls_Selected(), for: .selected)
            lifeSignButton.setImage(R.image.ic_ls_unSelected(), for: .normal)
            lifeSignButton.titleLabel?.font = Constants.backButtonFont
            lifeSignButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var gameButton: UIButton! {
        didSet {
            gameButton.setImage(R.image.ic_game_selected(), for: .selected)
            gameButton.setImage(R.image.ic_game_unselected(), for: .normal)
            gameButton.titleLabel?.font = Constants.backButtonFont
            gameButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var servicesButton: UIButton! {
        didSet {
            servicesButton.setImage(R.image.ic_services_selected(), for: .selected)
            servicesButton.setImage(R.image.ic_services_unselected(), for: .normal)
            servicesButton.titleLabel?.font = Constants.backButtonFont
            servicesButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var watchAddButton: UIButton! {
        didSet {
            watchAddButton.titleLabel?.font = Constants.headerSubTitleFont
            watchAddButton.isSkeletonable = true
        }
    }
    @IBOutlet weak var shopTableView: UITableView! {
        didSet {
            shopTableView.separatorStyle = .none
            shopTableView.isSkeletonable = true
            shopTableView.register(R.nib.shopCell)
        }
    }
    
    @IBOutlet weak var restorePurchaseButton: UIButton! {
        didSet {
            restorePurchaseButton.titleLabel?.font = Constants.headerSubTitleFont
            restorePurchaseButton.isSkeletonable = true
        }
    }
    
    @IBOutlet weak var otherAppsButton: UIButton! {
        didSet {
            otherAppsButton.titleLabel?.font = Constants.headerSubTitleFont
            otherAppsButton.isSkeletonable = true
        }
    }
    // MARK:- PROPERTIES -
    
    private var skProductsDS: [SKProduct] = [SKProduct]()
    private var skProductsGame: [SKProduct] = [SKProduct]()
    private var skProductsServices: [SKProduct] = [SKProduct]()
    var purchasedID: String = ""
    
    
    // MARK:- VIEW LIFECYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setText()
        observerLanguageChange()
        implementUnityAds()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- FUNCTIONS -
    
    func setUI () {
        SKPaymentQueue.default().add(self)
        lifeSignButton.isSelected = true
        implementUnityAds()
    }
    
    func implementUnityAds() {
        UnityAds.initialize(Constants.DEV_APP_ID, testMode: true)
        UnityAds.add(self)
    }
    
    @objc func handleRedirect(notification: NSNotification) {
        if let object = notification.object as? [String: Int] {
            let type = object["shopIndex"]!
            if type == 0 {
                self.didTapLSButton(self.lifeSignButton)
            } else if type == 1 {
                self.didTapGameButton(self.gameButton)
            } else if type == 2 {
                self.didTapServicesButton(self.servicesButton)
            }
        }
    }
    
    @objc func setText() {
        self.lifeSignButton.setTitle(AppStrings.getDailySignTitle(), for: .normal)
        self.gameButton.setTitle(AppStrings.getGameTitle(), for: .normal)
        self.servicesButton.setTitle(AppStrings.getServicesTitle(), for: .normal)
        
        lifeSignButton.alignTextUnderImage()
        gameButton.alignTextUnderImage()
        servicesButton.alignTextUnderImage()
        updateAdButtonText()
        
        otherAppsButton.setTitle(AppStrings.getDownloadAppsButtonText(), for: .normal)
        
        self.restorePurchaseButton.setTitle(AppStrings.restorePurchases(), for: .normal)
        
        self.shopTableView.reloadData()
    }
    
    func updateAdButtonText() {
        watchAddButton.setTitle(servicesButton.isSelected ? AppStrings.getWatchVidTwoSMS() : AppStrings.getWatchVidTwoClicks(), for: .normal)
        fetchProducts()
    }
    
    func observerLanguageChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: .languageCanged, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRedirect(notification:)),
                                               name: .redirectToShop,
                                               object: nil)
    }
    
    
    private func fetchProducts() {
        if lifeSignButton.isSelected {
            self.skProductsDS.removeAll()
            self.shopTableView.reloadData()
            let request = SKProductsRequest(productIdentifiers: Set(Constants.DailySignShopItems.compactMap({$0})))
            request.delegate = self
            request.start()
        } else if gameButton.isSelected {
            self.skProductsGame.removeAll()
            self.shopTableView.reloadData()
            let request = SKProductsRequest(productIdentifiers: Set(Constants.PokeGameShopItems.compactMap({$0})))
            request.delegate = self
            request.start()
        } else if servicesButton.isSelected {
            self.skProductsServices.removeAll()
            self.shopTableView.reloadData()
            let request = SKProductsRequest(productIdentifiers: Set(Constants.ServicesShopItems.compactMap({$0})))
            request.delegate = self
            request.start()
        }
    }
    
    private func saveInAppInDataBase() {
        self.showSpinner(onView: self.view)
        var newPurchaseId = self.purchasedID
        
        if self.purchasedID == "" {
            return
        }
        
        let twelveIndex = self.purchasedID.index(self.purchasedID.startIndex, offsetBy: 12)
        newPurchaseId.insert(contentsOf: "Dev", at: twelveIndex)
        
        print("NewSre: \(newPurchaseId)")
        
        LifeSignManager.savePackageInDatabase(identifier: newPurchaseId, transaction_id: Helper.getRandomAlphaNumericString(length: 8)) { status, errors in
            self.removeSpinner()
            if errors == nil {
                AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getPurchaseSuccessString(), style: .success, controller: self)
            } else {
                ErrorHandler.handleError(errors: errors ?? [""], inController: self)
            }
        }
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func didTapOtherAppButton(_ sender: UIButton) {
        sender.showAnimation {
            guard let otherAppVc = R.storyboard.game.otherAppsVC() else {
                return
            }
            self.push(controller: otherAppVc, animated: true)
        }
    }
    @IBAction func didTapLSButton(_ sender: UIButton) {
        lifeSignButton.isSelected = true
        gameButton.isSelected = false
        servicesButton.isSelected = false
        
        updateAdButtonText()
    }
    @IBAction func didTapGameButton(_ sender: UIButton) {
        lifeSignButton.isSelected = false
        gameButton.isSelected = true
        servicesButton.isSelected = false
        
        updateAdButtonText()
    }
    @IBAction func didTapServicesButton(_ sender: UIButton) {
        lifeSignButton.isSelected = false
        gameButton.isSelected = false
        servicesButton.isSelected = true
        
        updateAdButtonText()
    }
    
    @IBAction func didTapWatchAd(_ sender: UIButton) {
        sender.showAnimation {
            UnityAds.show(self, placementId: Constants.DEV_VIDE_AD_PLACEMENT, showDelegate: self)
        }
    }
    
    @IBAction func didTapRestorePurchaseButton(_ sender: UIButton) {
        sender.showAnimation {
            self.showSpinner(onView: self.view)
            if (SKPaymentQueue.canMakePayments()) {
              SKPaymentQueue.default().restoreCompletedTransactions()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.removeSpinner()
                
                AlertController.showAlert(witTitle: AppStrings.getSuccessString(), withMessage: AppStrings.getRestoreSuccessString(), style: .success, controller: self)
                
            }
        }
    }
    
    @IBAction func didTapBuyProduct(_ sender: UIButton) {
        
        if lifeSignButton.isSelected {
            let payment = SKPayment(product: self.skProductsDS[sender.tag])
            self.purchasedID = payment.productIdentifier
            SKPaymentQueue.default().add(payment)
        } else if gameButton.isSelected {
            let payment = SKPayment(product: self.skProductsGame[sender.tag])
            self.purchasedID = payment.productIdentifier
            SKPaymentQueue.default().add(payment)
        } else if servicesButton.isSelected {
            let payment = SKPayment(product: self.skProductsServices[sender.tag])
            self.purchasedID = payment.productIdentifier
            SKPaymentQueue.default().add(payment)
        }
    }
}


extension ShopVC: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if lifeSignButton.isSelected {
            return skProductsDS.count == 0 ? 5 : skProductsDS.count
        } else if gameButton.isSelected {
            return skProductsGame.count == 0 ? 5 : skProductsGame.count
        } else if servicesButton.isSelected {
            return skProductsServices.count == 0 ? 5 : skProductsServices.count
        }
        return 0
    }
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
           return "ShopCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.shopCell, for: indexPath)
        var product: SKProduct = SKProduct()
        cell?.showAnimation()
        
        
        if lifeSignButton.isSelected && skProductsDS.count > 0 {
            cell?.removeAnimation()
            product = skProductsDS[indexPath.row]
            cell?.buyButton.tag = indexPath.row
            cell?.priceButton.tag = indexPath.row
            cell?.buyButton.addTarget(self, action: #selector(didTapBuyProduct(_:)), for: .touchUpInside)
            cell?.priceButton.addTarget(self, action: #selector(didTapBuyProduct(_:)), for: .touchUpInside)
            
            
            switch indexPath.row {
            case 0:
                // 2 Extra Contacts
                cell?.configureCell(title: StringsManager.shared.two_extra_contacts ?? "2 Extra Contacts", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 1:
                // 10 Extra Contacts
                cell?.configureCell(title: StringsManager.shared.ten_extra_contacts ?? "10 Extra Contacts", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 2:
                // Unlimitted Extra Contacts
                cell?.configureCell(title: StringsManager.shared.unlimited_extra_contacts ?? "Unlimited Extra Contacts", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            default:
                print("red")
            }
            
        } else if gameButton.isSelected && skProductsGame.count > 0 {
            cell?.removeAnimation()
            product = skProductsGame[indexPath.row]
            cell?.buyButton.tag = indexPath.row
            cell?.priceButton.tag = indexPath.row
            cell?.buyButton.addTarget(self, action: #selector(didTapBuyProduct(_:)), for: .touchUpInside)
            cell?.priceButton.addTarget(self, action: #selector(didTapBuyProduct(_:)), for: .touchUpInside)
            
            switch indexPath.row {
            case 0:
                // 20 Auto Clicks
                cell?.configureCell(title: StringsManager.shared.twenty_hund_auto_clicks ?? "20 Auto clicks", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 1:
                // 200 Auto Clicks
                cell?.configureCell(title: StringsManager.shared.two_hund_auto_clicks ?? "200 Auto clicks", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 2:
                // 500 Auto Clicks
                cell?.configureCell(title: StringsManager.shared.five_hun_auto_clicks ?? "500 Auto clicks", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 3:
                // 1000 Auto Clicks
                cell?.configureCell(title: StringsManager.shared.thousand_auto_clicks ??  "1000 Auto clicks", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 4:
                // 5000 Auto Clicks
                cell?.configureCell(title: StringsManager.shared.five_thousand_auto_clicks ?? "5000 Auto clicks", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 5:
                // 2 Extra Games
                cell?.configureCell(title: StringsManager.shared.two_ext_poke_games ?? "2 Extra Poke Games", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 6:
                // 10 Extra Games
                cell?.configureCell(title: StringsManager.shared.ten_ext_poke_games ?? "10 Extra Poke Games", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 7:
                // Unlimitted Extra Games
                cell?.configureCell(title: StringsManager.shared.unli_ext_poke_games ?? "Unlimited Extra Poke Games", price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            default:
                print("de")
            }
        } else if servicesButton.isSelected && skProductsServices.count > 0 {
            cell?.removeAnimation()
            product = skProductsServices[indexPath.row]
            cell?.buyButton.tag = indexPath.row
            cell?.priceButton.tag = indexPath.row
            cell?.buyButton.addTarget(self, action: #selector(didTapBuyProduct(_:)), for: .touchUpInside)
            cell?.priceButton.addTarget(self, action: #selector(didTapBuyProduct(_:)), for: .touchUpInside)
            
            switch indexPath.row {
            case 0:
                // Ads Cell
                cell?.configureCell(title: AppStrings.getRemoveAdsInBottom(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 1:
                // 8 Extra SMS
                cell?.configureCell(title: AppStrings.getEightExtraSMS(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 2:
                // 25 Extra SMS
                cell?.configureCell(title: AppStrings.getTwentyFiveExtraSMS(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 3:
                // 100 Extra SMS
                cell?.configureCell(title: AppStrings.getHundredExtraSMS(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 4:
                // Message 140 to 1 Contact
                cell?.configureCell(title: AppStrings.msg_140_1_contact(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 5:
                // Message 140 to 10 Contact
                cell?.configureCell(title: AppStrings.msg_140_10_contact(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            case 6:
                // Message 140 to Unlimitted
                cell?.configureCell(title: AppStrings.msg_140_unlimitted_contact(), price: "\(product.priceLocale.currencySymbol ?? "$") \(product.price)", buyButton: AppStrings.getBuyString())
            default:
                print("de")
            }
            
            
        }
        
        return cell ?? ShopCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}



extension ShopVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        self.showSkeleton()
        transactions.forEach({
            switch $0.transactionState {
            case .purchased:
                print("Item Purchased")
                self.hideSkeleton()
                self.saveInAppInDataBase()
                SKPaymentQueue.default().finishTransaction($0)
            case .failed:
                print("Failed To Purchased")
                self.hideSkeleton()
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("Purchased Restored")
                self.hideSkeleton()
                SKPaymentQueue.default().finishTransaction($0)
            case .deferred:
                print("Defferred")
                self.hideSkeleton()
            case .purchasing:
                print("Purchasing In Process")
                self.hideSkeleton()
            @unknown default:
                self.hideSkeleton()
                SKPaymentQueue.default().finishTransaction($0)
                return
            }
        })
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.hideSkeleton()
            if self.lifeSignButton.isSelected {
                self.skProductsDS.removeAll()
                
                print("Products Received", response.products.count)
                self.skProductsDS.append(contentsOf: response.products)
                self.shopTableView.reloadData()
                
                for (index, _) in self.skProductsDS.enumerated() {
                    self.skProductsDS = self.skProductsDS.sorted { p1, p2 in
                        if index < Constants.DailySignShopItems.count {
                            return p1.productIdentifier == Constants.DailySignShopItems[index]
                        } else {
                            return false
                        }
                        
                    }
                }
                
                self.skProductsDS = self.skProductsDS.reversed()
                
                self.shopTableView.reloadData()
            } else if self.gameButton.isSelected {
                self.skProductsGame.removeAll()
                
                print("Products Received", response.products.count)
                self.skProductsGame.append(contentsOf: response.products)
                self.shopTableView.reloadData()
                
                for (index, _) in self.skProductsGame.enumerated() {
                    self.skProductsGame = self.skProductsGame.sorted { p1, p2 in
                        if index < Constants.PokeGameShopItems.count {
                            return p1.productIdentifier == Constants.PokeGameShopItems[index]
                        } else {
                            return false
                        }
                        
                    }
                }
                
                self.skProductsGame = self.skProductsGame.reversed()
                
                self.shopTableView.reloadData()
            } else if self.servicesButton.isSelected {
                self.skProductsServices.removeAll()
               
                print("Products Received", response.products.count)
                self.skProductsServices.append(contentsOf: response.products)
                self.shopTableView.reloadData()
                
                
                for (index, _) in self.skProductsServices.enumerated() {
                    self.skProductsServices = self.skProductsServices.sorted { p1, p2 in
                        
                        if index < Constants.ServicesShopItems.count {
                            return p1.productIdentifier == Constants.ServicesShopItems[index]
                        } else {
                            return false
                        }
                        
                    }
                }
                
                self.skProductsServices = self.skProductsServices.reversed()
                
                self.shopTableView.reloadData()
            }
        }
    }
}



extension ShopVC: UADSBannerViewDelegate, UnityAdsDelegate, UnityAdsShowDelegate {
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        print("Ads Completed: \(placementId)")
        
        switch state {
        case .showCompletionStateCompleted:
            print("Add Completed")
            GameManager.earnReward(rewardType: self.servicesButton.isSelected ? .rewardSMS : .rewardAutoClicks) { status, errors in
                if errors == nil {
                    AlertController.showAlert(witTitle: AppStrings.getCongratsString(), withMessage: self.servicesButton.isSelected ? AppStrings.getFreeSMSRewarded() : AppStrings.getReawardedClicks(), style: .success, controller: self)
                } else {
                    ErrorHandler.handleError(errors: errors ?? [""], inController: self)
                }
            }
            
        case .showCompletionStateSkipped:
            print("Add Skipped")
        default:
            return
        }
        
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        print("Ads Failed To Display: \(placementId)")
    }
    
    func unityAdsShowStart(_ placementId: String) {
        print("Ads Display Started: \(placementId)")
    }
    
    func unityAdsShowClick(_ placementId: String) {
        print("Ads Display Clicked: \(placementId)")
    }
    
    
    func unityAdsReady(_ placementId: String) {
        print("Ad Ready With ID: \(placementId)")
    }
    
    func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        print("Error Loading Unity Ad: \(message)")
    }
    
    func unityAdsDidStart(_ placementId: String) {
        print("Ad Started With ID: \(placementId)")
    }
    func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        print("Ad Finished With ID: \(placementId)")
    }
}
