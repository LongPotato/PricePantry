//
//  ProductDetailsTitle.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/8/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProductDetailsTitleViewCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var servingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
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
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(servingLabel)
        contentView.addSubview(divider)

        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -26).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: servingLabel.topAnchor, constant: -8).isActive = true

        servingLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        servingLabel.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -20).isActive = true
        servingLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        
        divider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        divider.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
