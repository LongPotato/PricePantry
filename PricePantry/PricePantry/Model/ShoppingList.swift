//
//  ShoppingList.swift
//  PricePantry
//
//  Created by khanhnguyen on 2/10/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//
import UIKit
import CoreData

extension ShoppingList {
    func addItem(for product: ProductMO, context: NSManagedObjectContext) {
        var productExisted = false
        
        if let items = self.items {
            // TODO: Revisit if see performance hit
            for item in items {
                let currentItem = item as! ShoppingItem
                if (currentItem.product == product) {
                    currentItem.quantity += 1;
                    productExisted = true
                }
            }
        }
        
        if (!productExisted) {
            let shoppingItem = ShoppingItem(context: context)
            shoppingItem.addedDate = Date()
            shoppingItem.product = product
            shoppingItem.quantity = 1
            shoppingItem.list = self
        }
    }
}
