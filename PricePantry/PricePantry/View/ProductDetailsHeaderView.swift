//
//  ProductDetailsHeader.swift
//  PricePantry
//
//  Created by Khanh Nguyen on 1/8/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

class ProductDetailsHeaderView: UIView {
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageViewHeightContraint: NSLayoutConstraint!
    var tableViewHeaderFrame: CGRect
    
    override init(frame: CGRect) {
        tableViewHeaderFrame = frame
        super.init(frame: frame)
        
        addSubview(containerView)
        
        containerView.widthAnchor.constraint(equalToConstant: tableViewHeaderFrame.width).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: tableViewHeaderFrame.height).isActive = true
        
        containerView.addSubview(productImageView)
        
        imageViewHeightContraint = productImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: 0)
        imageViewHeightContraint.isActive = true
        productImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        productImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
        containerView.addSubview(overlayView)
        
        overlayView.leftAnchor.constraint(equalTo: productImageView.leftAnchor).isActive = true
        overlayView.rightAnchor.constraint(equalTo: productImageView.rightAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor).isActive = true
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        updateImage(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(image: UIImage) {
        productImageView.image = image
    }
    
    func animateHeader() {
        imageViewHeightContraint.constant = tableViewHeaderFrame.height
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {self.layoutIfNeeded()}, completion: nil)
    }
    
    func scrollViewDidScoll(scrollView: UIScrollView) {
        // Stretchy header, stretch the header when pulling down
        let offsetY = -(scrollView.contentOffset.y)
        imageViewHeightContraint.constant = max(offsetY, 0)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView) {
    }
}
