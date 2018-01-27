//
//  NavigationExtension.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/26/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
