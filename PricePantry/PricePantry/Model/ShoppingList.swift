//
//  ShoppingList.swift
//  PricePantry
//
//  Created by khanhnguyen on 2/10/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//
import UIKit
import CoreData

extension CurrentShoppingList {
    
    func addItem(for product: ProductMO, context: NSManagedObjectContext) {
        if let list = self.list {
            let shoppingItem = ShoppingItem(context: context)
            shoppingItem.product = product
            shoppingItem.list = list
        }
    }
}
