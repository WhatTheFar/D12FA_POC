//
//  Extensions.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 12/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import Foundation

extension String {
    /**
     Subscript to allow for quick String substrings ["Hello"][0...1] = "He"
     */
    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let start = self.index(self.startIndex, offsetBy: r.lowerBound)
            let end = self.index(self.startIndex, offsetBy: r.upperBound - 1)
            return String(self[start..<end])
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var alpha: UInt32 = 255
        let hexLength = hex.count
        if !(hexLength == 7 || hexLength == 9) {
            // A hex must be either 7 or 9 characters (#RRGGBBAA)
            print("improper call to 'colorFromHex', hex length must be 7 or 9 chars (#RRGGBBAA)")
            self.init(white: 0, alpha: 1)
            return
        }
        
        var hexWithoutAlpha = hex
        if hexLength == 9 {
            // Scanning the int into the alpha var
            let s = Scanner(string: hex[7...8])
            s.scanHexInt32(&alpha)
            
            hexWithoutAlpha = hex[0...6]
        }
        
        // Establishing the rgb color
        var rgb: UInt32 = 0
        let s = Scanner(string: hexWithoutAlpha)
        // Setting the scan location to ignore the leading `#`
        s.scanLocation = 1
        // Scanning the int into the rgb colors
        s.scanHexInt32(&rgb)
        
        // Creating the UIColor from hex int
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
    
    func isWhite() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return false
        }
        
        return Int(red*100) == 0 && Int(green*100) == 0 && Int(blue*100) == 0
    }
}
