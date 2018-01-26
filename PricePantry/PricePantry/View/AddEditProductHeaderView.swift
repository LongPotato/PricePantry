//
//  AddEditProductHeaderView.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/25/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class AddEditProducHeaderView: UIView {
    let imagePicker: UIImageView = {
        var imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imagePicker)
        
        imagePicker.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        imagePicker.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        imagePicker.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        imagePicker.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
