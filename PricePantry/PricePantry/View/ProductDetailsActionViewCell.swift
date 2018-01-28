//
//  ProductDetailsAction.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/14/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProductDetailsActionViewCell : UITableViewCell {
    let addPriceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add price", for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cellActionDelegate: DetailsViewCellActionDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addPriceButton.addTarget(self, action: #selector(addPriceButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(addPriceButton)
        
        addPriceButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        addPriceButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        addPriceButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32).isActive = true
        addPriceButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addPriceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addPriceButtonTapped() {
        cellActionDelegate.addPriceButtonTapped()
    }
}
