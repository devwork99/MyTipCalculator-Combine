//
//  Double+Extension.swift
//  tip-calculator
//
//  Created by Yasir on 04/11/2024.
//

import Foundation



extension Double {
    var currencyFormatted : String {
        var isWholeNumber : Bool {
            isZero ? true: !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 1
        return formatter.string(for:self) ?? ""
    }
}
