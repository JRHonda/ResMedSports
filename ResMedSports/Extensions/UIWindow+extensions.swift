//
//  UIWindow+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/26/21.
//

import class UIKit.UIWindow
import class UIKit.UIView
import class UIKit.UIActivityIndicatorView
import class UIKit.UIColor
import class Foundation.DispatchQueue

extension UIWindow {
    //private static let association = ObjectAssociation<UIActivityIndicatorView>()
    private static let association = ObjectAssociation<UIView>()
    
    //var activityIndicator: UIActivityIndicatorView {
    var activityIndicator: UIView {
        set { UIWindow.association[self] = newValue }
        get {
            if let indicator = UIWindow.association[self] {
                return indicator
            } else {
                let indicatorView = UIActivityIndicatorView(style: .large)
                indicatorView.color = .black
                indicatorView.center = self.center
                indicatorView.startAnimating()
                let overlay = UIView(frame: self.frame)
                overlay.backgroundColor = UIColor.gray
                overlay.alpha = 0.8
                overlay.addSubview(indicatorView)
                UIWindow.association[self] = overlay
                return UIWindow.association[self]!
            }
        }
    }
    
    // MARK: - Activity Indicator
    public func startIndicatingActivity(_ ignoringEvents: Bool? = true) {
        DispatchQueue.main.async {
            self.addSubview(self.activityIndicator)
        }
    }
    
    public func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.activityIndicator.removeFromSuperview()
        }
    }
    
}
