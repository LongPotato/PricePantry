//
//  CenterActionButtonCell.swift
//  PricePantry
//
//  Created by khanhnguyen on 3/1/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class CenterActionButtonCell: BaseControlCell {
    let buttonText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setUpViews() {
        selectionStyle = .default
        
        contentView.addSubview(buttonText)
        
        buttonText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buttonText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
