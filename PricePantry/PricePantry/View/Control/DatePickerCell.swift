//
//  DatePickerCell.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/20/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class DatePickerCell: BaseControlCell {
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override func setUpViews() {
        addSubview(datePicker)
        
        datePicker.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        datePicker.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        datePicker.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
}
