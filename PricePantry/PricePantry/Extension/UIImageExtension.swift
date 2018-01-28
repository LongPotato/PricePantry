//
//  UIImageExtension.swift
//  PricePantry
//
//  Created by khanhnguyen on 1/27/18.
//  Copyright © 2018 Khanh Nguyen. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scaleRatio = newWidth / image.size.width
        let newHeight = image.size.height * scaleRatio
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
