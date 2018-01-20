//
//  ViewController.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    let searchBarController = UISearchController(searchResultsController: nil)
    let newProductButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Products"
        navigationItem.rightBarButtonItem = newProductButton
        
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        
        setUpProducts()
    }
    
    func setUpProducts() {
        let product1 = Product(name: "Jiff peanut butter, with a veryyyy long name like this. Let's see!!", image: #imageLiteral(resourceName: "food_can"))
        let product2 = Product(name: "Chicken breast", image: #imageLiteral(resourceName: "chicken"))
        let product3 = Product(name: "Banana")
        
        self.products = [product1, product2, product3]
        
        var prices: [Price] = []
        
        for i in 0...9 {
            let price = Price(price: 18.45, timeStamp: Date())
            if (i % 2 == 0) {
                price.store = "Costco"
            } else if (i % 3 == 0) {
                price.store = "Amazon"
            }
            prices.append(price)
        }
        
        product1.prices = prices
        product3.prices = prices
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        
        cell.updateCellData(product: products[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = ProducDetailsViewController(product: products[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

