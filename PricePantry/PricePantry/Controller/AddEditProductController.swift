//
//  AddEditProductController.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/25/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class AddEditProductController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var headerView: AddEditProducHeaderView!
    var productNameCell: LargeEntryCell!
    var product: ProductMO!
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
        navigationItem.title = "Add Product"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(submitProduct))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAndExitPage))
        
        headerView = AddEditProducHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePickerTapped)))
        tableView.tableHeaderView = headerView
        
        tableView.register(LargeEntryCell.self, forCellReuseIdentifier: String(describing: LargeEntryCell.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Tableview dataSource & delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        productNameCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LargeEntryCell.self), for: indexPath) as! LargeEntryCell
        productNameCell.updateHeight(constant: 100)
        productNameCell.inputTextField.placeholder = "Product name"
        return productNameCell
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
                
                present(alert, animated: true, completion: nil)
            } else {
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    product = ProductMO(context: appDelegate.persistentContainer.viewContext)
                    product.name = productNameCell.inputTextField.text
                    product.image = UIImagePNGRepresentation(headerView.imagePicker.image!)
                    
                    appDelegate.saveContext()
                    cancelAndExitPage()
                }
            }
        }
    }
}
