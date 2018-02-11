//
//  TodoListViewController.swift
//  PricePantry
//
//  Created by khanhnguyen on 2/10/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchResultController: NSFetchedResultsController<CurrentShoppingList>!
    
    var items: [ShoppingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Shopping"
        
        setUpData()
    }
    
    func setUpData() {
        let fetchRequest: NSFetchRequest<CurrentShoppingList> = CurrentShoppingList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            
            // Current shopping list fetch controller
            self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultController.delegate = self
            
            fetchList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchList()
        tableView.reloadData()
    }
    
    func fetchList() {
        do {
            try self.fetchResultController.performFetch()
            
            if let currentShoppingList = self.fetchResultController.fetchedObjects?.first {
                if let items = currentShoppingList.list!.items {
                    self.items = items.allObjects as! [ShoppingItem]
                }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: Tableview delegate & data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row].product!.name
        return cell
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
        
        if let currentShoppingList = controller.fetchedObjects?.first {
            let shoppingList = currentShoppingList as! CurrentShoppingList
            if let items = shoppingList.list!.items {
                self.items = items.allObjects as! [ShoppingItem]
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
