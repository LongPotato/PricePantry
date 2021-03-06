//
//  ProductTableViewCell.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/5/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    let productTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let productPrice: UILabel = {
        let priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        priceLabel.textColor = UIColor(red: 143/255, green: 142/255, blue: 148/255, alpha: 1)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(productTitle)
        contentView.addSubview(productImage)
        contentView.addSubview(productPrice)
        
        setUpCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCellLayout() {
        productTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        productTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26).isActive = true
        productTitle.rightAnchor.constraint(equalTo: productImage.leftAnchor, constant: -20).isActive = true
        productTitle.bottomAnchor.constraint(equalTo: productPrice.topAnchor, constant: -5).isActive = true
        
        productImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: 78).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: 78).isActive = true
        productImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
        productPrice.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        productPrice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        productPrice.rightAnchor.constraint(equalTo: productImage.leftAnchor, constant: -20).isActive = true
        productPrice.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func updateCellData(indexPath: IndexPath, product: ProductMO) {
        productPrice.text = nil
        productTitle.text = product.name
        productImage.image = nil
        
        tag = indexPath.row
        
        DispatchQueue.global(qos: .background).async(execute: {
            if let image = product.image {
                var convertedImage: UIImage!
                
                if let thumbnail = product.thumbnail {
                    // If a thumbnail version is available, use that
                    convertedImage = UIImage(data: thumbnail)
                } else {
                    // If not we resize the image to a thumbnail version, and save it
                    convertedImage = UIImage(data: image)
                    if let resizeImage = UIImage.resizeImage(image: convertedImage!, newWidth: 156) {
                        convertedImage = resizeImage
                        product.thumbnail = UIImageJPEGRepresentation(convertedImage, 1)
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    if (self.tag == indexPath.row) {
                        self.productImage.image = convertedImage
                    }
                })
            }
        })
        
        if let prices = product.prices?.allObjects as? [PriceMO], prices.count > 0 {
            // Display the most recent price
            productPrice.text = "$ " + String(prices[prices.count - 1].price)
        }
    }
}
