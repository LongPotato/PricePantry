//
//  LargeEntryCell.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/21/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class LargeEntryCell: BaseControlCell, UITextFieldDelegate {
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var heightConstraint: NSLayoutConstraint!
    
    override func setUpViews() {
        contentView.addSubview(inputTextField)
        
        inputTextField.delegate = self
        
        heightConstraint = inputTextField.heightAnchor.constraint(equalToConstant: 200)
        heightConstraint.isActive = true
        inputTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        inputTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func updateHeight(constant: Int) {
        heightConstraint.constant = CGFloat(integerLiteral: constant)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
