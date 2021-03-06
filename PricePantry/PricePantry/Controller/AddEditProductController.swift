//
//  AddEditProductController.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/25/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class AddEditProductController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EntryCellWithLabelDelegate  {
    let notificationHapticGenerator = UINotificationFeedbackGenerator()
    
    var headerView: AddEditProductHeaderView!
    var productNameCell: LargeEntryCell!
    var servingNumberCell: EntryCellWithLabel!
    var detailsTableView: UITableView?
    
    var product: ProductMO!
    var isCreatingNewProduct: Bool!
    var controllerActionDelegate: AddEditProductControllerDelegate?
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        isCreatingNewProduct = true
        
        navigationItem.title = "Add Product"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(submitProduct))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAndExitPage))
        
        headerView = AddEditProductHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePickerTapped)))
        tableView.tableHeaderView = headerView
        
        tableView.keyboardDismissMode = .onDrag
        
        tableView.register(LargeEntryCell.self, forCellReuseIdentifier: String(describing: LargeEntryCell.self))
        tableView.register(EntryCellWithLabel.self, forCellReuseIdentifier: String(describing: EntryCellWithLabel.self))
    }
    
    /**
     Contructor to use to edit an existing product
    */
    convenience init(product: ProductMO, style: UITableViewStyle) {
        self.init(style: style)
        self.product = product
        navigationItem.rightBarButtonItem?.title! = "Save"
        navigationItem.title = "Edit product"
        headerView.imagePicker.image = UIImage(data: product.image!)
        isCreatingNewProduct = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Tableview dataSource & delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            productNameCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LargeEntryCell.self), for: indexPath) as! LargeEntryCell
            productNameCell.updateHeight(constant: 100)
            productNameCell.inputTextField.placeholder = "Product name"
            
            if let product = product {
                productNameCell.inputTextField.text = product.name
            }
            
            return productNameCell
        }
        
        servingNumberCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EntryCellWithLabel.self), for: indexPath) as! EntryCellWithLabel
        servingNumberCell.cellActionDelegate = self
        servingNumberCell.updateLabels(keyboardType: .decimalPad, label: "Servings", placeHolder: "# Servings")
        
        if product != nil && product.servings > 0 {
            servingNumberCell.inputTextField.text = String(product.servings)
        }
        
        return servingNumberCell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 1) {
            return "Number of servings for one unit."
        }
        return nil
    }
    
    // MARK: Image picker
    
    @objc func imagePickerTapped() {
        let photoSourceRequestController = UIAlertController(title: nil, message: "Choose your photo source", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (action) in
            if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: {
            (action) in
            if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cancelAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            headerView.imagePicker.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation bar action
    
    @objc func cancelAndExitPage() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func submitProduct() {
        productNameCell.inputTextField.resignFirstResponder()
        
        if let name = productNameCell.inputTextField.text {
            if (name.isEmpty) {
                let alert = UIAlertController(title: "Error", message: "Name can not be blank", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                notificationHapticGenerator.notificationOccurred(.error)
                
                present(alert, animated: true, completion: nil)
            } else {
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    if (product == nil) {
                        // Create new product
                        product = ProductMO(context: appDelegate.persistentContainer.viewContext)
                        isCreatingNewProduct = true
                    }
                    
                    product.name = productNameCell.inputTextField.text
                    
                    let pickerImage = headerView.imagePicker.image!
                    product.image = UIImageJPEGRepresentation(pickerImage, 1)
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        // We want to resize the image to smaller size to optimize the load time
                        // Resize the images in background thread to prevent slow down
                        var productThumbnail: Data?
                        
                        if let resizeImage = UIImage.resizeImage(image: pickerImage, newWidth: 156) {
                            productThumbnail = UIImageJPEGRepresentation(resizeImage, 1)
                        }
                        
                        if let resizedMainImage = UIImage.resizeImage(image: pickerImage, newWidth: 840) {
                            self.product.image = UIImageJPEGRepresentation(resizedMainImage, 1)
                        }
                        
                        DispatchQueue.main.async{
                            self.product.thumbnail = productThumbnail
                            appDelegate.saveContext()
                        }
                    }
                    
                    if let servings = servingNumberCell.inputTextField.text, !servings.isEmpty {
                        product.servings = Double(servings)!
                    } else {
                        // No serving number entered, default to 0
                        product.servings = 0
                    }
                    
                    appDelegate.saveContext()
                    
                    // Reload deatails serving row & image if came from details view
                    if (detailsTableView != nil) {
                        let index = IndexPath(row: 0, section: 0)
                        detailsTableView?.reloadRows(at: [index], with: .fade)
                        
                        let deatailsHeader = detailsTableView?.tableHeaderView as! ProductDetailsHeaderView
                        deatailsHeader.productImageView.image = pickerImage
                    }
                    
                    cancelAndExitPage()
                    
                    if (isCreatingNewProduct) {
                        if (controllerActionDelegate != nil) {
                            controllerActionDelegate!.navigateToCreatedProductPage(product: product)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: EntryCellWithLabelDelegate
    
    func inputFieldTapped() {
    }
}
