//
//  APIManager.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIManager: NSObject {
    
    static let sharedManager = APIManager()
    
    private let kHostURL = "http://ec2-54-64-75-180.ap-northeast-1.compute.amazonaws.com/"
    
    
    // MARK: GET Methods

    
    func getProduct(completion: (product: Product) -> Void) {
        let url = kHostURL + "products/search"
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let json = response.result.value {
                        completion(product: Product(json: JSON(json)))
                    }
                } else {
                    // TODO: アラート出す
                }
        }
    }
}