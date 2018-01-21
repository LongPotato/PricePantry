//
//  EntryCellWithLabel.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/20/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class EntryCellWithLabel: BaseControlCell, UITextFieldDelegate {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.textAlignment = .right
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var cellActionDelegate: AddEditPriceCellActionDelegate!
    
    override func setUpViews() {
        addSubview(nameLabel)
        addSubview(inputTextField)
        
        inputTextField.delegate = self
        
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        inputTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 5).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }
    
    func updateLabels(keyboardType: UIKeyboardType, label: String, placeHolder: String) {
        nameLabel.text = label
        inputTextField.placeholder = placeHolder
        inputTextField.keyboardType = keyboardType
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cellActionDelegate.inputFieldTapped()
    }
}
