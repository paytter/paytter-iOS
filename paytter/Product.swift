//
//  Product.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import SwiftyJSON

class Product: NSObject {
    var price: Int?
    var category: String?
    var detail: Detail?
    var imageUrl: String?
    var itemId: String?
    var score: String?
    var sites: Site?
    
    init(json: JSON) {
        price = json["price"].int
        category = json["candidates"]["category"].string
        imageUrl = json["candidates"]["imageUrl"].string
        itemId = json["candidates"]["itemId"].string
        score = json["candidates"]["score"].string
        detail = Detail.getDetail(json["candidates"])
        sites = Site.getSite(json["candidates"])
    }
    
    class Detail {
        var brand: String?
        var itemName: String?
        var maker: String?
        var quantity: Int?
        var releaseDate: String?
        
        init (json: JSON) {
            brand = json["brand"].string
            itemName = json["itemName"].string
            maker = json["maker"].string
            quantity = Int(json["quantity"].string!)
            releaseDate = json["releaseDate"].string
        }
        
        class func getDetail(json: JSON) -> Detail {
            let detail = Detail(json: json["detail"])
            
            return detail
        }
    }
    
    class Site {
        var imageUrl: String?
        var title: String?
        var url: String?
        
        init (json: JSON) {
            imageUrl = json["imageUrl"].string
            title = json["title"].string
            url = json["url"].string
        }
        
        class func getSite(json: JSON) -> Site {
            let site = Site(json: json["site"])
            
            return site
        }
    }
    
    func addItem() {
        detail?.quantity? += 1
    }
    
    func removeItem() {
        detail?.quantity? -= 1
    }
}
