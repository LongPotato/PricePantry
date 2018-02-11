//
//  ViewController.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddEditProductControllerDelegate, UISearchResultsUpdating {
    let searchBarController = UISearchController(searchResultsController: nil)
    var fetchResultController: NSFetchedResultsController<ProductMO>!
    
    var products: [ProductMO] = []
    var searchResults: [ProductMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarController.searchResultsUpdater = self
        searchBarController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Products"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProduct))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        tableView.showsVerticalScrollIndicator = false
        
        tableView.backgroundView = TableViewBackgroundLoadingView()
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        
        setUpProducts()
    }
    
    func setUpProducts() {
        
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
        
        let fetchRequest: NSFetchRequest<ProductMO> = ProductMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

            // Fetch the data from storage in the background
            DispatchQueue.global(qos: .userInitiated).async {
                let context = appDelegate.persistentContainer.viewContext
                self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                self.fetchResultController.delegate = self
                
                do {
                    try self.fetchResultController.performFetch()
                    if let fetchedObjects = self.fetchResultController.fetchedObjects {
                        DispatchQueue.main.async {
                            self.products = fetchedObjects
                            self.tableView.reloadData()
                            
                            self.tableView.backgroundView?.isHidden = true
                            self.tableView.separatorStyle = .singleLine
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: TableView dataSource & delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarController.isActive {
            return searchResults.count;
        } else {
            return products.count;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        
        let product = searchBarController.isActive ? searchResults[indexPath.row] : products[indexPath.row]
        cell.updateCellData(indexPath: indexPath, product: product)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var product = products[indexPath.row]
        
        if (searchBarController.isActive) {
            product = searchResults[indexPath.row]
            // Disable search controller so we can push to navigation controller
            searchBarController.isActive = false
        }
        
        navigateToProductPage(product: product)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: {
            (action, sourceView, completionHandler) in
            
            let confirmAlert = UIAlertController(title: "Comfirm", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let productToDelete = self.fetchResultController.object(at: indexPath)
                    
                    context.delete(productToDelete)
                    
                    if let pricesToDelete = productToDelete.prices?.allObjects as? [PriceMO] {
                        for price in pricesToDelete {
                            context.delete(price)
                        }
                    }
                    
                    appDelegate.saveContext()
                    completionHandler(true)
                }
            })
            
            let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
                completionHandler(false)
            })

            confirmAlert.addAction(yesAction)
            confirmAlert.addAction(noAction)
            
            self.present(confirmAlert, animated: true, completion: nil)
        })
        
        let editAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            let productToEdit = self.fetchResultController.object(at: indexPath)
            let controller = AddEditProductController(product: productToEdit, style: .grouped)
            let newProductController = UINavigationController(rootViewController: controller)
            
            self.present(newProductController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete-context")
        
        editAction.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        editAction.image = #imageLiteral(resourceName: "edit-context")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfiguration
    }
    
    // MARK: Navgiation bar action
    
    @objc func addNewProduct() {
        let controller = AddEditProductController(style: .grouped)
        controller.controllerActionDelegate = self
        let newProductController = UINavigationController(rootViewController: controller)
        present(newProductController, animated: true, completion: nil)
    }
    
    func navigateToProductPage(product: ProductMO) {
        let detailsViewController = ProducDetailsViewController(product: product)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    // MARK: Add edit product controller protocol
    
    func navigateToCreatedProductPage(product: ProductMO) {
        navigateToProductPage(product: product)
    }
    
    // MARK: CoreData delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            products = fetchedObjects as! [ProductMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: Search bar delegate & methods
    
    func filterContent(for searchText: String) {
        searchResults = products.filter({
            (product) -> Bool in
            if let name = product.name {
                let isMatch = name.localizedStandardContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}

