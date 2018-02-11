//
//  ProductDetailsView.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit
import CoreData

class ProducDetailsViewController: UITableViewController, DetailsViewCellActionDelegate, NSFetchedResultsControllerDelegate {
    private var product: ProductMO!
    private var prices: [PriceMO]! = []
    private var defaultTintColor: UIColor?
    private let tableViewHeaderHeight: CGFloat = 210
    var headerView: ProductDetailsHeaderView!
    var fetchResultController: NSFetchedResultsController<PriceMO>!
    
    init() {
        super.init(style: .plain)
    }
    
    convenience init(product: ProductMO) {
        self.init()
        self.product = product
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "edit-nav"), style: .plain, target: self, action: #selector(editProduct))
        navigationItem.title = "Details"
        
        tableView.register(ProductDetailsTitleViewCell.self, forCellReuseIdentifier: String(describing: ProductDetailsTitleViewCell.self))
        tableView.register(ProductDetailsActionViewCell.self, forCellReuseIdentifier: String(describing: ProductDetailsActionViewCell.self))
        tableView.register(ProductPriceViewCell.self, forCellReuseIdentifier: String(describing: ProductPriceViewCell.self))
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        headerView = ProductDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tableViewHeaderHeight))
        if let image = product.image {
            let uiImage = UIImage(data: image)
            headerView.updateImage(image: uiImage!)
        } else {
            headerView.updateImage(image: #imageLiteral(resourceName: "placeholder"))
        }
        
        tableView.tableHeaderView = headerView
        
        // Tint color of this view is white.
        // Save the blue tint color so when we exit this view we can restore it.
        defaultTintColor = navigationController?.navigationBar.tintColor
        
        setUpPrices()
    }
    
    func setUpPrices() {
        let fetchRequest: NSFetchRequest<PriceMO> = PriceMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        fetchRequest.predicate = NSPredicate(format: "product == %@", product)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    prices = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Tableview dataSource & delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            // Section for Title & Action cells
            return 2
        default:
            // Section for price cells
            return prices.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductDetailsTitleViewCell.self)) as! ProductDetailsTitleViewCell
                cell.nameLabel.text = product?.name
                
                if product.servings > 0 {
                    cell.servingLabel.text = "Servings: " + String(product.servings)
                } else {
                    cell.servingLabel.text = nil
                }
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductDetailsActionViewCell.self)) as! ProductDetailsActionViewCell
                cell.cellActionDelegate = self
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductPriceViewCell.self)) as! ProductPriceViewCell
            cell.updateData(price: prices[indexPath.row])
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1) {
            return 60
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 0) {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Because price cells are at section 1, but NSFetchedResult expects section 0
        var index = indexPath
        index.section = 0
        
        let copyAction = UIContextualAction(style: .normal, title: "Copy") { (action, sourceView, completionHandler) in
            let priceToEdit = self.fetchResultController.object(at: index)
            
            let controller = AddEditPriceController(price: priceToEdit, style: .grouped)
            controller.selectedProduct = self.product
            controller.copyingPrice = true
            let newPriceController = UINavigationController(rootViewController: controller)
            
            self.present(newPriceController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        copyAction.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [copyAction])
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Because price cells are at section 1, but NSFetchedResult expects section 0
        var index = indexPath
        index.section = 0
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (action, sourceView, completionHandler) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                
                let priceToDelete = self.fetchResultController.object(at: index)
                
                context.delete(priceToDelete)
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        })
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            let priceToEdit = self.fetchResultController.object(at: index)
            
            let controller = AddEditPriceController(price: priceToEdit, style: .grouped)
            controller.selectedProduct = self.product
            let newPriceController = UINavigationController(rootViewController: controller)
            
            self.present(newPriceController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        editAction.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeConfiguration
    }
    
    // MARK: Scrollview delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerView.scrollViewDidScoll(scrollView: scrollView)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerView.scrollViewDidEndDecelerating(scrollView: scrollView)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        headerView.scrollViewDidEndDragging(scrollView: scrollView)
    }
    
    // MARK: DetailsViewCellActionDelegate
    
    func addPriceButtonTapped() {
        let controller = AddEditPriceController(style: .grouped)
        controller.selectedProduct = product
        let newPriceController = UINavigationController(rootViewController: controller)
        
        present(newPriceController, animated: true, completion: nil)
    }
    
    // MARK: CoreData delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case .insert:
            if let newIndexPath = newIndexPath {
                let index = getPriceCellIndexPath(indexPath: newIndexPath)
                tableView.insertRows(at: [index], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                let index = getPriceCellIndexPath(indexPath: indexPath)
                tableView.deleteRows(at: [index], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let index = getPriceCellIndexPath(indexPath: indexPath)
                tableView.reloadRows(at: [index], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            prices = fetchedObjects as! [PriceMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // MARK: Navigation
    
    @objc func editProduct() {
        let controller = AddEditProductController(product: product, style: .grouped)
        controller.detailsTableView = tableView
        let newProductController = UINavigationController(rootViewController: controller)
        
        self.present(newProductController, animated: true, completion: nil)
    }
    
    // MARK: Helper function
    
    func getPriceCellIndexPath(indexPath: IndexPath) -> IndexPath {
        // Price cells are at section 1
        return IndexPath(row: indexPath.row, section: 1)
    }
}
