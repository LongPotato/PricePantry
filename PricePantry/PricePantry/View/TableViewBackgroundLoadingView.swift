//
//  TableViewBackgroundLoadingView.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/29/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class TableViewBackgroundLoadingView: UIView {
    let loadingSpinner: UIActivityIndicatorView  = {
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func layoutSubviews() {
        backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        addSubview(loadingSpinner)
        
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimating()
        
        loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
