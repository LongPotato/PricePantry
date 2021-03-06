//
//  AddEditPriceController.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/20/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class AddEditPriceController: UITableViewController, EntryCellWithLabelDelegate {
    var priceCell: EntryCellWithLabel!
    var storeCell: EntryCellWithLabel!
    var selectDatePickerCell: UITableViewCell!
    var datePickerCell: DatePickerCell!
    var quantityCell: EntryCellWithLabel!
    var unitPriceCell: UITableViewCell!
    var notesCell: LargeEntryCell!
    
    var selectDatePickerCellIndexPath: IndexPath!
    let displayCellIndentifier = "displayCelIndentifier"
    var datePickerCellDisplayed = false
    
    var selectedProduct: ProductMO!
    var copyingPrice: Bool = false
    var price: PriceMO?
    var detailsPageTableView: UITableView?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(price: PriceMO, style: UITableViewStyle) {
        self.init(style: style)
        self.price = price
    }
    
    override func viewDidLoad() {
        navigationItem.title = "New Price"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(submitPrice))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAndExitPage))
        
        if price != nil {
            if (copyingPrice) {
                navigationItem.title = "Copy Price"
            } else {
                navigationItem.rightBarButtonItem?.title = "Save"
                navigationItem.title = "Edit Price"
            }
        }
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(EntryCellWithLabel.self, forCellReuseIdentifier: String(describing: EntryCellWithLabel.self))
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: String(describing: DatePickerCell.self))
        tableView.register(LargeEntryCell.self, forCellReuseIdentifier: String(describing: LargeEntryCell.self))
    }
    
    // MARK: Tableview
    
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
            priceCell = getEntryCellWithLabel(indexPath: indexPath, keyboard: .decimalPad, label: "$", placeHolderText: "Price")
            priceCell.inputTextField.addTarget(self, action: #selector(priceInputChanged), for: .editingChanged)
            
            if let price = price {
                priceCell.inputTextField.text = String(price.price)
            }
            
            return priceCell
        case 1:
            // Store & Date & Quantity section
            switch(indexPath.row) {
            case 0:
                // Store cell
                storeCell = getEntryCellWithLabel(indexPath: indexPath, keyboard: .default, label: "Store", placeHolderText: "Name")
                
                if let price = price {
                    storeCell.inputTextField.text = price.store
                }
                
                return storeCell
            case 1:
                // Select date cell
                selectDatePickerCellIndexPath = indexPath
                selectDatePickerCell = getValue1DisplayCell(label: "Date")
                
                var dateToDisplay = Date()
                
                if let price = price, !copyingPrice {
                    dateToDisplay = price.timeStamp!
                }
                
                let strDate = formatDateToString(dateTime: dateToDisplay)
                
                selectDatePickerCell.detailTextLabel!.text = strDate
                selectDatePickerCell.detailTextLabel!.textColor = .black
                return selectDatePickerCell!
            case 2:
                if (datePickerCellDisplayed) {
                    // Date picker cell
                    datePickerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: DatePickerCell.self), for: indexPath) as? DatePickerCell
                    datePickerCell.datePicker.datePickerMode = .date
                    datePickerCell.datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
                    
                    if let price = price {
                        if (copyingPrice) {
                            datePickerCell.datePicker.setDate(Date(), animated: true)
                        } else {
                            datePickerCell.datePicker.setDate(price.timeStamp!, animated: true)
                        }
                    }
                    
                    return datePickerCell
                } else {
                    // Quantity cell
                    quantityCell = getEntryCellWithLabel(indexPath: indexPath, keyboard: .decimalPad, label: "Quantiy", placeHolderText: "# Unit")
                    quantityCell.inputTextField.addTarget(self, action: #selector(priceInputChanged), for: .editingChanged)
                    
                    if let price = price {
                        quantityCell.inputTextField.text = String(price.quantity)
                    }
                    
                    return quantityCell
                }
            default:
                // Unit price cell
                unitPriceCell = getValue1DisplayCell(label: "Unit Price")
                unitPriceCell.detailTextLabel!.text = "$0"
                
                if price != nil {
                    priceInputChanged()
                }
                
                return unitPriceCell
            }
        default:
            // Notes section, notes cell
            notesCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LargeEntryCell.self)) as! LargeEntryCell
            notesCell.inputTextField.placeholder = "Notes"
            notesCell.updateHeight(constant: 150)
            
            if let price = price {
                notesCell.inputTextField.text = price.notes
            }
            
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
    
    // MARK: Helper func
    
    func getDatePickerIndexPath(selectCellIndexPath: IndexPath) -> IndexPath {
        return IndexPath(row: selectCellIndexPath.row + 1, section: 1)
    }
    
    func formatDateToString(dateTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let strDate = formatter.string(from: dateTime)
        return strDate
    }
    
    func formatStringToDate(dateStr: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let date = formatter.date(from: dateStr)
        return date
    }
    
    // MARK: AddEditPriceCellActionDelegate
    
    func inputFieldTapped() {
        let datepickeIndexPath = getDatePickerIndexPath(selectCellIndexPath: selectDatePickerCellIndexPath)
        toggleDatePickerCell(indexPath: datepickeIndexPath)
    }
    
    // MARK: Update price values
    
    @objc func datePickerChanged(_ picker: UIDatePicker) {
        let strDate = formatDateToString(dateTime: picker.date)
        selectDatePickerCell.detailTextLabel!.text = strDate
    }
    
    @objc func priceInputChanged() {
        let price = getPriceValue()
        let quantity = getQuantityValue()
        let unitPrice = calculateUnitPrice(price: price, quantity: quantity)
        
        unitPriceCell.detailTextLabel!.text = "$" + String(format: "%.2f", unitPrice)
    }
    
    // MARK: Navigation bar action
    
    @objc func submitPrice() {
        let price = getPriceValue()
        let quantity = getQuantityValue()
        let unitPrice = calculateUnitPrice(price: price, quantity: quantity)
        let timeStamp = getTimeStampValue()
        let store = getStoreNameValue()
        let notes = getNotesValue()
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            var priceObject: PriceMO
            
            if let selectedPrice = self.price {
                if (copyingPrice) {
                    // Copy existing price as new price
                    priceObject = PriceMO(context: appDelegate.persistentContainer.viewContext)
                } else {
                    // Edit existing price
                    priceObject = selectedPrice
                }
            } else {
                // Create new price
                priceObject = PriceMO(context: appDelegate.persistentContainer.viewContext)
            }
            
            priceObject.price = price
            priceObject.quantity = quantity
            priceObject.unitPrice = unitPrice
            priceObject.timeStamp = timeStamp
            priceObject.store = store
            priceObject.notes = notes
            priceObject.product = selectedProduct
            
            appDelegate.saveContext()
        }
        
        cancelAndExitPage()
    }
    
    @objc func cancelAndExitPage() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Parse & validate values
    
    func getPriceValue() -> Double {
        var price = 0.0
        
        if let priceText = priceCell.inputTextField.text, !priceText.isEmpty {
            price = Double(priceText)!
        }
        return price
    }
    
    func getQuantityValue() -> Double {
        var denominator = 1.0
        
        if let quantity = quantityCell.inputTextField.text, !quantity.isEmpty {
            denominator = Double(quantity)!
            if (denominator == 0) {
                denominator = 1
            }
        }
        return denominator
    }
    
    func calculateUnitPrice(price: Double, quantity: Double) -> Double {
        return price / quantity
    }
    
    func getTimeStampValue() -> Date {
        let dateStr = selectDatePickerCell.detailTextLabel!.text!
        if let date = formatStringToDate(dateStr: dateStr) {
            return date
        }
        return Date()
    }
    
    func getStoreNameValue() -> String {
        var storeName = ""
        
        if let name = storeCell.inputTextField.text {
            storeName = name
        }
        return storeName
    }
    
    func getNotesValue() -> String {
        var notesText = ""
        
        if let text = notesCell.inputTextField.text {
            notesText = text
        }
        return notesText
    }
}
