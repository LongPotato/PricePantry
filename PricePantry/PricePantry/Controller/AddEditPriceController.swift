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
    let displayCellIndentifier = "displayCelIndentifier"
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
        tableView.register(LargeEntryCell.self, forCellReuseIdentifier: String(describing: LargeEntryCell.self))
    }
    
    @objc func cancelAndExitPage() {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            if (datePickerCellDisplayed) {
                return 5
            } else {
                return 4
            }
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            // Price section, price cell
            return getEntryCellWithLabel(indexPath: indexPath, keyboard: .decimalPad, label: "$", placeHolderText: "Price")
        case 1:
            // Store & Date & Quantity section
            switch(indexPath.row) {
            case 0:
                // Store cell
                return getEntryCellWithLabel(indexPath: indexPath, keyboard: .default, label: "Store", placeHolderText: "Name")
            case 1:
                // Select date cell
                selectDatePickerCellIndexPath = indexPath
                let selectDatePickerCell = getValue1DisplayCell(label: "Date")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                let strDate = formatter.string(from: Date())
                
                selectDatePickerCell.detailTextLabel!.text = strDate
                selectDatePickerCell.detailTextLabel!.textColor = .black
                return selectDatePickerCell
            case 2:
                if (datePickerCellDisplayed) {
                    // Date picker cell
                    let datePickerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: DatePickerCell.self), for: indexPath) as! DatePickerCell
                    datePickerCell.datePicker.datePickerMode = .date
                    return datePickerCell
                } else {
                    // Quantity cell
                    return getEntryCellWithLabel(indexPath: indexPath, keyboard: .decimalPad, label: "Quantiy", placeHolderText: "# Unit")
                }
            default:
                // Unit price cell
                let unitPriceCell = getValue1DisplayCell(label: "Unit Price")
                unitPriceCell.detailTextLabel!.text = "$10"
                return unitPriceCell
            }
        default:
            // Notes section, notes cell
            let notesCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LargeEntryCell.self)) as! LargeEntryCell
            notesCell.inputTextField.placeholder = "Notes"
            return notesCell
        }
        
    }
    
    func getEntryCellWithLabel(indexPath: IndexPath, keyboard: UIKeyboardType, label: String, placeHolderText: String) -> EntryCellWithLabel {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EntryCellWithLabel.self), for: indexPath) as! EntryCellWithLabel
        cell.updateLabels(keyboardType: keyboard, label: label, placeHolder: placeHolderText)
        cell.cellActionDelegate = self
        return cell
    }
    
    func getValue1DisplayCell(label: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: displayCellIndentifier)
        cell.selectionStyle = .none
        cell.textLabel!.text = label
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (selectDatePickerCellIndexPath.row == indexPath.row) {
            // If date picker select cell is selected, dismiss all the keyboard
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        toggleDatePickerCell(indexPath: indexPath)
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
    
    func getDatePickerIndexPath(selectCellIndexPath: IndexPath) -> IndexPath {
        return IndexPath(row: selectCellIndexPath.row + 1, section: 1)
    }
    
    // MARK: AddEditPriceCellActionDelegate
    
    func inputFieldTapped() {
        let datepickeIndexPath = getDatePickerIndexPath(selectCellIndexPath: selectDatePickerCellIndexPath)
        toggleDatePickerCell(indexPath: datepickeIndexPath)
    }
}
