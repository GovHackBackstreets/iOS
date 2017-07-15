//
//  designableView.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 15/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class designView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowColour: UIColor? = UIColor.black
    @IBInspectable let shadowOffsetWidth: Int = 0
    @IBInspectable let shadowOffsetHeight: Int = 3
    @IBInspectable var shadowOpacity: Float =  0.2
    
    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColour?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        let shadow = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadow.cgPath
        layer.shadowOpacity = shadowOpacity
        
    }
    
}
