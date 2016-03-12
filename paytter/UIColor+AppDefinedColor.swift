//
//  UIColor+AppDefinedColor.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience public init(rgb: Int64) {
        let red   = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue  = CGFloat((rgb & 0x0000FF))  / 255.0
        let alpha = CGFloat(0xFF)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience public init(rgba: Int64) {
        let red   = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue  = CGFloat((rgba & 0x0000FF00) >> 8)  / 255.0
        let alpha = CGFloat( rgba & 0x000000FF)        / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // 青色
    class func navigationBarColor() -> UIColor {
        return UIColor(rgb: 0x359BD2)
    }
}
