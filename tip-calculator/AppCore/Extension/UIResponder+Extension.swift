//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by Yasir on 30/10/2024.
//

import UIKit


extension UIResponder {
    
    var parentViewController : UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
    
    
}
