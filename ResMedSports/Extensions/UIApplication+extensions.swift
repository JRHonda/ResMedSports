//
//  UIApplication+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/26/21.
//

import UIKit.UIApplication

extension UIApplication {
    // MARK: - Key Window
    var keyWindow: UIWindow? {
        get {
            return UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
        }
    }
}
