//
//  ViewController.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddEditProductControllerDelegate {
    let searchBarController = UISearchController(searchResultsController: nil)
    var fetchResultController: NSFetchedResultsController<ProductMO>!
    
    var products: [ProductMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "Products"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProduct))
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 96
        tableView.showsVerticalScrollIndicator = false
        
        setUpProducts()
    }
    
    func setUpProducts() {
        let fetchRequest: NSFetchRequest<ProductMO> = ProductMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    products = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: TableView dataSource & delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as! ProductTableViewCell
        
        cell.updateCellData(indexPath: indexPath, product: products[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToProductPage(product: products[indexPath.row])
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
    
}

