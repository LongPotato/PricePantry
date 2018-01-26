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
        addSubview(inputTextField)
        
        inputTextField.delegate = self
        
        heightConstraint = inputTextField.heightAnchor.constraint(equalToConstant: 200)
        heightConstraint.isActive = true
        inputTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        inputTextField.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateHeight(constant: Int) {
        heightConstraint.constant = CGFloat(integerLiteral: constant)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
