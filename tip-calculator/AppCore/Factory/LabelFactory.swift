//
//  LabelFactory.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit

struct LabelFactory {
        
    static func build(text:String?,
                      font:UIFont,
                      textColor:UIColor = ThemeColors.text,
                      backgroundColor:UIColor = .clear,
                      alignment:NSTextAlignment = .center) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.textAlignment = alignment
        return label
    }

    
    
    
}
