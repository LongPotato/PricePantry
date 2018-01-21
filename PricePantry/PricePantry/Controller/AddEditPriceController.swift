//
//  AddEditPriceController.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/20/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class AddEditPriceController: UITableViewController, AddEditPriceCellActionDelegate {
    var selectDatePickerCellIndexPath: IndexPath!
    let selectDatePickerCellIndentifier = "selectDatePickerCell"
    var datePickerCellDisplayed = false
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.title = "New Price"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAndExitPage))
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(EntryCellWithLabel.self, forCellReuseIdentifier: String(describing: EntryCellWithLabel.self))
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: String(describing: DatePickerCell.self))
    }
    
    @objc func cancelAndExitPage() {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            if (datePickerCellDisplayed) {
                return 3
            } else {
                return 2
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            // Price section
            let priceCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EntryCellWithLabel.self), for: indexPath) as! EntryCellWithLabel
            priceCell.updateLabels(keyboardType: .decimalPad, label: "$", placeHolder: "Price")
            priceCell.cellActionDelegate = self
            return priceCell
        default:
            // Store & Date section
            switch(indexPath.row) {
            case 0:
                let storeCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EntryCellWithLabel.self), for: indexPath) as! EntryCellWithLabel
                storeCell.updateLabels(keyboardType: .default, label: "Store", placeHolder: "Name")
                storeCell.cellActionDelegate = self
                return storeCell
            case 1:
                selectDatePickerCellIndexPath = indexPath
                let selectDatePickerCell = UITableViewCell(style: .value1, reuseIdentifier: selectDatePickerCellIndentifier)
                selectDatePickerCell.selectionStyle = .none
                selectDatePickerCell.textLabel!.text = "Date"
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let strDate = formatter.string(from: Date())
                
                selectDatePickerCell.detailTextLabel!.text = strDate
                return selectDatePickerCell
            default:
                let datePickerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: DatePickerCell.self), for: indexPath) as! DatePickerCell
                datePickerCell.datePicker.datePickerMode = .date
                return datePickerCell
            }

        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectDatePickerCellIndexPath.row == indexPath.row) {
            // If date picker select cell is selected, dismiss all the keyboard
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        toggleDatePickerCell(indexPath: indexPath)
    }
    
    func getDatePickerIndexPath(selectCellIndexPath: IndexPath) -> IndexPath {
        return IndexPath(row: selectCellIndexPath.row + 1, section: 1)
    }
    
    func toggleDatePickerCell(indexPath: IndexPath) {
        tableView.beginUpdates()
        if (selectDatePickerCellIndexPath.row == indexPath.row && !datePickerCellDisplayed) {
            // Selected date picker select cell when picker is not visible, display date picker cell
            datePickerCellDisplayed = true
            let datePickerIndexPath = getDatePickerIndexPath(selectCellIndexPath: selectDatePickerCellIndexPath)
            tableView.insertRows(at: [datePickerIndexPath], with: .middle)
        } else if (datePickerCellDisplayed) {
            // Select any other cell when picker is visible, close the date picker cell
            datePickerCellDisplayed = false
            let datePickerIndexPath = getDatePickerIndexPath(selectCellIndexPath: selectDatePickerCellIndexPath)
            tableView.deleteRows(at: [datePickerIndexPath], with: .middle)
        }
        tableView.endUpdates()
    }
    
    func inputFieldTapped() {
        let datepickeIndexPath = getDatePickerIndexPath(selectCellIndexPath: selectDatePickerCellIndexPath)
        toggleDatePickerCell(indexPath: datepickeIndexPath)
    }
}
