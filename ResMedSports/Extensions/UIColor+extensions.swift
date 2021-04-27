//
//  UIColor+extensions.swift
//  ResMedSports
//
//  Created by Justin Honda on 4/27/21.
//

import UIKit

infix operator |: AdditionPrecedence
public extension UIColor {
    
    /// Easily define two colors for both light and dark mode.
    /// - Parameters:
    ///   - lightMode: The color to use in light mode.
    ///   - darkMode: The color to use in dark mode.
    /// - Returns: A dynamic color that uses both given colors respectively for the given user interface style.
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
    static private let overlayColor = UIColor.black
    
    static var screenOverlayColor: UIColor {
        get {
            return overlayColor.withAlphaComponent(0.2) | overlayColor
        }
    }
    
    /// must have all RGB components to use this initializer
    convenience init(with components: [CGFloat], alpha: CGFloat, isClear: Bool = false) {
        if components.count < 3 {
            fatalError("This convenience initializer requires all 3 RGB components.")
        }
        var trueAlpha: CGFloat = 1
        if isClear {
            trueAlpha = 0
        }
        self.init(red: components[0], green: components[1], blue: components[2], alpha: trueAlpha)
    }
    
    class var black: UIColor {
        get {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    class var white: UIColor {
        get {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    class var lightGray: UIColor {
        get {
            let factor: CGFloat = 2/3
            return UIColor(red: factor, green: factor, blue: factor, alpha: 1)
        }
    }
    
    class var darkGray: UIColor {
        get {
            let factor: CGFloat = 1/3
            return UIColor(red: factor, green: factor, blue: factor, alpha: 1)
        }
    }
    
    class var gray: UIColor {
        get {
            let factor: CGFloat = 0.5
            return UIColor(red: factor, green: factor, blue: factor, alpha: 1)
        }
    }
    
    class var clear: UIColor {
        get {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    func complimentary(alpha: CGFloat = 1, isClear: Bool = false) -> UIColor? {
        if let components = self.cgColor.components?.compactMap({ (component) -> CGFloat in
            return 1 - component
        }) {
            return UIColor(with: components, alpha: alpha, isClear: isClear)
        }
        return nil
    }
    
}
