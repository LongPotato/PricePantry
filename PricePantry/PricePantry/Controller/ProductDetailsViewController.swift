//
//  ProductDetailsView.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProducDetailsViewController: UITableViewController, DetailsViewCellActionDelegate {
    private var product: Product?
    private var defaultTintColor: UIColor?
    private let tableViewHeaderHeight: CGFloat = 250
    var headerView: ProductDetailsHeaderView!
    
    init() {
        super.init(style: .plain)
    }
    
    convenience init(product: Product) {
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
        if let image = product?.image {
            headerView.updateImage(image: image)
        } else {
            headerView.updateImage(image: #imageLiteral(resourceName: "placeholder"))
        }
        
        tableView.tableHeaderView = headerView
        
        // Tint color of this view is white.
        // Save the blue tint color so when we exit this view we can restore it.
        defaultTintColor = navigationController?.navigationBar.tintColor
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
            return product!.prices.count
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
            cell.updateData(price: product!.prices[indexPath.row])
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
        controller.detailsPageTableView = tableView
        let newPriceController = UINavigationController(rootViewController: controller)
        present(newPriceController, animated: true, completion: nil)
    }
}
