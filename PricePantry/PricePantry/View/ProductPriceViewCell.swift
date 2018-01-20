//
//  PriceCell.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/19/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProductPriceViewCell: UITableViewCell {
    let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 138/255, green: 138/255, blue: 143/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var divider: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(divider)
        
        leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        leftLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        leftLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        rightLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        divider.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(price: Price) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let strDate = formatter.string(from: price.timeStamp)
        
        var leftLabelText = strDate
        
        if let store = price.store {
            leftLabelText += " - " + store
        }
            
        leftLabel.text = leftLabelText
        rightLabel.text = "$" + String(price.price)
    }
}
