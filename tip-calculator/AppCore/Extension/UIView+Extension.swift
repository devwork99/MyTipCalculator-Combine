//
//  UIView+Extension.swift
//  tip-calculator
//
//  Created by Yasir on 02/10/2024.
//

import UIKit

extension UIView {
    
    func addShadow(offSet:CGSize, color:UIColor, radius:CGFloat, opacity:Float){
        
        layer.cornerRadius = radius
        layer.masksToBounds = false
        
        layer.shadowOffset = offSet
        layer.shadowColor = color.cgColor
        
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }

    func addCornorRadius(radius:CGFloat){
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRounderCorners(corners:CACornerMask, radius:CGFloat){
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}



