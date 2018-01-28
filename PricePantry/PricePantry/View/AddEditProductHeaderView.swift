//
//  AddEditProductHeaderView.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/25/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class AddEditProductHeaderView: UIView {
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
        
        imagePicker.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imagePicker.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imagePicker.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imagePicker.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
