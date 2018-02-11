//
//  TabBarController.swift
//  PricePantry
//
//  Created by khanhnguyen on 2/10/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productsTab = UINavigationController(rootViewController: ProductTableViewController())
        productsTab.tabBarItem = UITabBarItem(title: "Products", image: #imageLiteral(resourceName: "price-list-icon"), tag: 0)
        
        let todoListTag = UINavigationController(rootViewController: ProductTableViewController())
        todoListTag.tabBarItem = UITabBarItem(title: "Shopping", image: #imageLiteral(resourceName: "todo-list-icon"), tag: 0)
        
        viewControllers = [productsTab, todoListTag]
    }
    
}
