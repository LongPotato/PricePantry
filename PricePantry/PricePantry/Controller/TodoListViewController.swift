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
    var fetchResultController: NSFetchedResultsController<ShoppingItem>!
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var shoppingList: ShoppingList?
    var items: [ShoppingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Shopping"
        
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: String(describing: TodoItemTableViewCell.self))
        
        setUpData()
    }
    
    func setUpData() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            
            // Current shopping list fetch request
            let shoppingFetchRequest = NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
            let shoppingPredicate = NSPredicate(format: "current == true")
            shoppingFetchRequest.predicate = shoppingPredicate
            
            do {
                // Perform shopping list fetch
                self.shoppingList = try context.fetch(shoppingFetchRequest).first
                
                if let shoppingList = self.shoppingList {
                    // Fetch all items of this current shopping list
                    let fetchRequest: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
                    let sortDescriptor = NSSortDescriptor(key: "addedDate", ascending: true)
                    let predicate = NSPredicate(format: "list == %@", shoppingList)
                    fetchRequest.sortDescriptors = [sortDescriptor]
                    fetchRequest.predicate = predicate
                    
                    // Shopping items fetch controller
                    self.fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                    self.fetchResultController.delegate = self
                    
                    fetchList()
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchList()
        tableView.reloadData()
    }
    
    func fetchList() {
        do {
            try self.fetchResultController.performFetch()
            
            if let items = self.fetchResultController.fetchedObjects {
                self.items = items
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TodoItemTableViewCell.self)) as! TodoItemTableViewCell
        let item = items[indexPath.row]
        
        if (item.checked) {
            cell.checkedIcon.image = #imageLiteral(resourceName: "checked-icon")
        } else {
            cell.checkedIcon.image = #imageLiteral(resourceName: "unchecked-icon")
        }
        
        if (item.quantity > 1) {
            cell.nameLabel.text = item.product!.name! + " (x" + String(item.quantity) + ")"
        } else {
            cell.nameLabel.text = item.product!.name!
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                
                let itemToDelete = self.items[indexPath.row]
                
                context.delete(itemToDelete)
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        })
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let itemToUpdate = items[indexPath.row]
            itemToUpdate.checked = !itemToUpdate.checked
            
            appDelegate.saveContext()
            
            impactFeedbackGenerator.impactOccurred()
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
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
        
        if let items = self.fetchResultController.fetchedObjects {
            self.items = items
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
