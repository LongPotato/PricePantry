//
//  TodoItemTableViewCell.swift
//  PricePantry
//
//  Created by khanhnguyen on 2/11/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
    let checkedIcon: UIImageView =  {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        contentView.addSubview(checkedIcon)
        contentView.addSubview(nameLabel)
        
        checkedIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        checkedIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkedIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        checkedIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        nameLabel.leftAnchor.constraint(equalTo: checkedIcon.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
