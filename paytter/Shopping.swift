//
//  Shopping.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import SwiftyJSON

class Shopping: NSObject {
    var productId: Int?
    var numberOfProduct: Int?
    var storeId: Int?
    var action: Action?
    
    enum Action: String {
        case New = "new"
        case Increase = "increase"
        case Decrease = "decrease"
        case Cancel = "cancel"
    }
    
    init(productId: Int, numberOfProduct: Int, storeId: Int, action: Action) {
        self.productId = productId
        self.numberOfProduct = numberOfProduct
        self.storeId = storeId
        self.action = action
    }
    
    func convertToParams() -> [String : AnyObject] {
        let params = ["shopping" :
        ["product_id": productId ?? 0,
            "number_of_product" : numberOfProduct ?? 0,
            "store_id": storeId ?? 0,
            "action": action?.rawValue ?? ""]]
        
        return params
    }

}
