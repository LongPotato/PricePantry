//
//  TableEmptyMessageView.swift
//  PricePantry
//
//  Created by khanhnguyen on 3/2/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class TableEmptyMessageView: UIView {
    let message: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(message)
        
        message.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        message.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        message.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
