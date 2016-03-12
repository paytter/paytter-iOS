//
//  Cart.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/13.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class Cart: NSObject {

    static let sharedManager = Cart()
    
    var products = [Product]()
    
    func getTotalPrice() -> Int {
        var totalPrice = 0
        for product in products {
            totalPrice += product.price ?? 0
        }
        return totalPrice
    }
}
