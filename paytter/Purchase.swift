//
//  Purchase.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/13.
//  Copyright © 2016年 ITF. All rights reserved.
//

import SwiftyJSON

class Purchase: NSObject {
    var productId: Int?
    var numberOfProducts: Int?
    var storeId: Int?
    var totalAmounts: Int?
    
    init(productId: Int, numberOfProducts: Int, storeId: Int, totalAmounts: Int) {
        self.productId = productId
        self.numberOfProducts = numberOfProducts
        self.storeId = storeId
        self.totalAmounts = totalAmounts
    }
    
    func convertToParams() -> [String : AnyObject] {
        let params = ["purchase" :
            ["store_id": storeId ?? 0,
                "total_amounts" : totalAmounts ?? 0,
                "purchase_informations": [
                    "product_id" : productId ?? 0,
                    "number_of_products" : numberOfProducts ?? 0
                ]
            ]
        ]
        
        return params
    }
}
