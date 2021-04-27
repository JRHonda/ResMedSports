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
    
    static func isDeviceJailBrokenCanOpenUrl() -> Bool {
        if let url = URL(string: "cydia://package/com.example.package") {
            if UIApplication.shared.canOpenURL(url) {
                return true
            }
            return false
        }
        return false
    }
    
    static func isDeviceJailBrokenFileCheck() ->Bool {
        if access("/Applications/Cydia.app", F_OK) != -1 || access("/Applications/blackra1n.app", F_OK) != -1 || access("/Applications/FakeCarrier.app", F_OK) != -1 || access("/Applications/Icy.app", F_OK) != -1 || access("/Applications/IntelliScreen.app", F_OK) != -1 || access("/Applications/MxTube.app", F_OK) != -1 || access("/Applications/RockApp.app", F_OK) != -1 || access("/Applications/SBSettings.app", F_OK) != -1 || access("/Applications/WinterBoard.app", F_OK) != -1 || access("/Library/MobileSubstrate/MobileSubstrate.dylib", F_OK) != -1 || access("/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist", F_OK) != -1 || access("/Library/MobileSubstrate/DynamicLibraries/Veency.plist", F_OK) != -1 || access("/private/var/lib/apt", F_OK) != -1 || access("/private/var/lib/cydia", F_OK) != -1 || access("/private/var/mobile/Library/SBSettings/Themes", F_OK) != -1 || access("/private/var/stash", F_OK) != -1 || access("/private/var/tmp/cydia.log", F_OK) != -1 || access("/System/Library/LaunchDaemons/com.ikey.bbot.plist", F_OK) != -1 || access("/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist", F_OK) != -1 || access("/usr/bin/sshd", F_OK) != -1 || access("/usr/libexec/sftp-server", F_OK) != -1 || access("/usr/sbin/sshd", F_OK) != -1 || access("/bin/bash", F_OK) != -1 || access("/etc/apt", F_OK) != -1 {
            return true
        }
        return false
    }
}
