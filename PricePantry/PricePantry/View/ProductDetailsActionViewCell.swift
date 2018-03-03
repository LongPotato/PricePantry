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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addToShoppingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to shopping", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cellActionDelegate: DetailsViewCellActionDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addPriceButton.addTarget(self, action: #selector(addPriceButtonTapped), for: .touchUpInside)
        addToShoppingButton.addTarget(self, action: #selector(addToShoppingButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(addPriceButton)
        contentView.addSubview(addToShoppingButton)
        
        addPriceButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        addPriceButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        addPriceButton.rightAnchor.constraint(equalTo: addToShoppingButton.leftAnchor, constant: -9).isActive = true
        addPriceButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addPriceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        addToShoppingButton.topAnchor.constraint(equalTo: addPriceButton.topAnchor).isActive = true
        addToShoppingButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5, constant: -25).isActive = true
        addToShoppingButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        addToShoppingButton.bottomAnchor.constraint(equalTo: addPriceButton.bottomAnchor).isActive = true
        addToShoppingButton.heightAnchor.constraint(equalTo: addPriceButton.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addPriceButtonTapped() {
        cellActionDelegate.addPriceButtonTapped()
    }
    
    @objc func addToShoppingButtonTapped() {
        cellActionDelegate.addToShoppingButtonTapped()
    }
}
