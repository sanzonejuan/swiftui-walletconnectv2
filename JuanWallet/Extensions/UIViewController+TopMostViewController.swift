//
//  UIViewController+TopMostViewController.swift
//  JuanWallet
//
//  Created by Juan Sanzone on 28/02/2023.
//

import UIKit

extension UIViewController {
    
    static func topMostViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes: UIWindowScene? = scenes.first as? UIWindowScene
        let windows: [UIWindow]? = windowScenes?.windows
        let keyWindow = windows?.filter { $0.isKeyWindow }.first
        return keyWindow?.rootViewController?.topMostViewController()
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.topMostViewController()
        } else if let tabBarController = self as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController.topMostViewController()
            }
            return tabBarController.topMostViewController()
        } else if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        } else {
            return self
        }
    }
}
