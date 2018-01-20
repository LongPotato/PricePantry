//
//  SampleTestViewController.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/15/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class SampleTestViewController: UIViewController {
    private var defaultTintColor: UIColor?
    var headerView: ProductDetailsHeaderView!
    var tableView: UITableView!
    var product: Product?
    
    let headerViewHeight: CGFloat = 350
    var headerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        defaultTintColor = navigationController?.navigationBar.tintColor
        
        setUpHeaderView()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func setUpHeaderView() {
        headerView = ProductDetailsHeaderView(frame: CGRect.zero)
        if let image = product?.image {
            headerView.updateImage(image: image)
        }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerViewHeight)
        headerHeightConstraint.isActive = true
    }
    
    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        
        tableView.register(ProductDetailsTitleViewCell.self, forCellReuseIdentifier: String(describing: ProductDetailsTitleViewCell.self))
        tableView.register(ProductDetailsActionViewCell.self, forCellReuseIdentifier: String(describing: ProductDetailsActionViewCell.self))
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func animateHeader() {
        headerHeightConstraint.constant = headerViewHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {self.view.layoutIfNeeded()}, completion: nil)
    }
}

extension SampleTestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductDetailsTitleViewCell.self)) as! ProductDetailsTitleViewCell
            cell.nameLabel.text = product?.name
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductDetailsActionViewCell.self)) as! ProductDetailsActionViewCell
            return cell
        }
    }
}

extension SampleTestViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let navigationBarHeight = view.safeAreaInsets.top
        if (scrollView.contentOffset.y < 0) {
            // Pulling down
            // Sketch the header
            //tableView.bounces = true
            headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
        } else if (scrollView.contentOffset.y > 0 && headerHeightConstraint.constant >= navigationBarHeight) {
            // Pulling up and the header is bigger than the navigation bar
            // Reduce the header
            //tableView.bounces = false
            headerHeightConstraint.constant -= scrollView.contentOffset.y / 100
            
            if (headerHeightConstraint.constant < navigationBarHeight) {
                // Stop decreasing the height when it's the same height as the navigation bar
                headerHeightConstraint.constant = navigationBarHeight
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (headerHeightConstraint.constant > headerViewHeight) {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (headerHeightConstraint.constant > headerViewHeight) {
            animateHeader()
        }
    }
}
