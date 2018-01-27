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
    private let tableViewHeaderHeight: CGFloat = 250
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
        
        tableView.register(ProductDetailsTitleViewCell.self, forCellReuseIdentifier: String(describing: ProductDetailsTitleViewCell.self))
        tableView.register(ProductDetailsActionViewCell.self, forCellReuseIdentifier: String(describing: ProductDetailsActionViewCell.self))
        tableView.register(ProductPriceViewCell.self, forCellReuseIdentifier: String(describing: ProductPriceViewCell.self))
        
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        if let tintColor = defaultTintColor {
            navigationController?.navigationBar.tintColor = tintColor
        }
    }
    
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
                let index = IndexPath(row: newIndexPath.row, section: 1) // Prices are at section 1
                tableView.insertRows(at: [index], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                let index = IndexPath(row: indexPath.row, section: 1)
                tableView.deleteRows(at: [index], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let index = IndexPath(row: indexPath.row, section: 1)
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
}
