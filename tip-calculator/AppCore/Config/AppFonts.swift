//
//  AppFonts.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
//https://developer.apple.com/fonts/system-fonts/

struct AppFont {
    
    static func regular(_ size:CGFloat) -> UIFont {
        return UIFont(name:"AvenirNext-Regular", size: size) ?? .systemFont(ofSize:size)
    }
    
    static func bold(_ size:CGFloat) -> UIFont {
        return UIFont(name:"AvenirNext-Bold", size: size) ?? .systemFont(ofSize:size)
    }
    
    static func demibold(_ size:CGFloat) -> UIFont {
        return UIFont(name:"AvenirNext-DemiBold", size: size) ?? .systemFont(ofSize:size)
    }
    
    
}
