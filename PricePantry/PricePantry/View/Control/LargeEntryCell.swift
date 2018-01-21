//
//  LargeEntryCell.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/21/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class LargeEntryCell: BaseControlCell {
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setUpViews() {
        addSubview(inputTextField)
        
        inputTextField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        inputTextField.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
