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
    var action: String?
    
    override init() {
    }
    
    func convertToParams() -> [String : String] {
        var params: [String : String] = [:]
        
        if let productId = productId {
            params["product_id"] = productId.description
        }
        if let numberOfProduct = numberOfProduct {
            params["number_of_product"] = numberOfProduct.description
        }
        if let storeId = storeId {
            params["store_id"] = storeId.description
        }
        if let action = action {
            params["action"] = action
        }
        
        return params
    }

}
