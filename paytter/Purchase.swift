//
//  Purchase.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/13.
//  Copyright © 2016年 ITF. All rights reserved.
//

import SwiftyJSON

class Purchase: NSObject {
    var storeId: Int?
    
    init(storeId: Int) {
        self.storeId = storeId
    }
    
    func convertToParams() -> [String : AnyObject] {
        var informationValues = [AnyObject]()
        var informationValue = [String : String]()
        for product in Cart.sharedManager.products {
            informationValue["product_id"] = product.itemId ?? ""
            informationValue["number_of_products"] = product.detail?.quantity?.description ?? ""
            informationValues.append(informationValue)
        }
        
        let params = ["purchase" :
            ["store_id": storeId ?? 0,
                "total_amounts" : Cart.sharedManager.getTotalPrice() ?? 0,
                "purchase_informations": informationValues
            ]
        ]
        
        return params
    }
}
