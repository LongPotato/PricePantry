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
        let shoppingItem = ShoppingItem(context: context)
        shoppingItem.addedDate = Date()
        shoppingItem.product = product
        shoppingItem.list = self
    }
}
