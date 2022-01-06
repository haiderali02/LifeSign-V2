//
//  AlertController.swift
//  LifeSign
//
//  Created by Haider Ali on 25/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation
import NotificationBannerSwift


class CustomBannerColors: BannerColorsProtocol {

    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .danger:    // Your custom .danger color
                return R.color.appRedColor() ?? .systemRed
            case .info:        // Your custom .info color
                return R.color.appOrangeColor() ?? .systemOrange
            case .customView:    // Your custom .customView color
                return R.color.appBackgroundColor() ?? .systemGray
            case .success:    // Your custom .success color
                return R.color.appDarkGreenColor() ?? .systemGreen
            case .warning:    // Your custom .warning color
                return R.color.appYellowColor() ?? .systemYellow
        }
    }
}

class AlertController: NSObject {
    static func showAlert(witTitle: String, withMessage: String, style: BannerStyle, controller: UIViewController) {
        let bannerView = FloatingNotificationBanner(title: witTitle != "" ? witTitle : nil, subtitle: withMessage, titleFont: witTitle != "" ? Constants.bigButtonFont : nil , titleColor: witTitle != "" ? .white : nil, titleTextAlign: witTitle != "" ? .left : nil, subtitleFont: Constants.labelFont, subtitleColor: .white, subtitleTextAlign: .left, leftView: nil, rightView: nil, style: style, colors: CustomBannerColors(), iconPosition: .top)
        bannerView.duration = 1.5
        bannerView.show(on: controller)
    }
    
    static func showNativeAlert(title: String = AppStrings.getAlertString(), message: String, controller: UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AppStrings.getOKButtonString(), style: .default, handler: { _ in
            //
        }))
        controller.present(alertController, animated: true, completion: nil)
    }
    
}


