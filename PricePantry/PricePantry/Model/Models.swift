//
//  Models.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class Product {
    var name: String
    var image: UIImage?
    var prices: [Price]
    
    convenience init (name: String) {
        self.init(name: name, image: nil)
    }
    
    init(name: String, image: UIImage?) {
        self.name = name
        self.image = image
        prices = []
    }
}

class Price {
    var price: Double
    var timeStamp: Date
    var store: String?
    var notes: String?
    var quantity: Double?
    var unitPrice: Double?
    
    init(price: Double, timeStamp: Date) {
        self.price = price
        self.timeStamp = timeStamp
    }
}
