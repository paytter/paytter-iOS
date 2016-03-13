//
//  APIManager.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import Alamofire
import SwiftyJSON
import JDStatusBarNotification

class APIManager: NSObject {
    
    static let sharedManager = APIManager()
    
    private let kHostURL = "http://ec2-54-64-75-180.ap-northeast-1.compute.amazonaws.com/"
    
    override init() {
        super.init()
        
        configureNotificationStyle()
    }
    
    private var headers: [String : String] {
        get {
//            return NSUserDefaults.standardUserDefaults().objectForKey("headers") as? [String : String] ?? ["" : ""]
            return ["Authorization" : "y32aBv6m4s2NDgGpvzCg1abDAJsaFTqa"]
        }
    }
    
    private func configureNotificationStyle() {
        JDStatusBarNotification.addStyleNamed("style", prepare: {
            (style: JDStatusBarStyle!) -> JDStatusBarStyle! in
            style.textColor = .whiteColor()
            style.barColor = .errorColor()
            style.font = UIFont.boldSystemFontOfSize(18)
            style.animationType = JDStatusBarAnimationType.Move
            return style
        })
    }
    
    
    // MARK: GET Methods
    
    func getProduct(storeId storeId: Int, eanId: Int?, isbnId: Int?, itemIds: String?, completion: (product: Product) -> Void) {
        let url = kHostURL + "products/search"
        
        var params: [String : AnyObject] = ["store_id" : storeId]
        
        if let itemIds = itemIds {
            params["item_ids"] = itemIds
        }
        if let eanId = eanId {
            params["ean_id"] = eanId
        }
        if let isbnId = isbnId {
            params["isbn_id"] = isbnId
        }
        
        Alamofire.request(.GET, url, parameters: params)
            .responseJSON { response in
                if response.result.isSuccess {
                    if let json = response.result.value {
                        completion(product: Product(json: JSON(json)))
                    }
                } else {
                    JDStatusBarNotification.showWithStatus("商品情報を取得できませんでした", dismissAfter: 3, styleName: "style")
                }
        }
    }


    // MARK: Post Methods
    
    func postShopping(shopping: Shopping) {
        let url = kHostURL + "shoppings"
        Alamofire.request(.POST, url, parameters: shopping.convertToParams(), headers: headers)
    }

    func postPurchase(purchase: Purchase) {
        let url = kHostURL + "purchases"
        Alamofire.request(.POST, url, parameters: purchase.convertToParams(), headers: headers)
        Cart.sharedManager.products.removeAll()
    }

    func postUser(params: [String: AnyObject]) {
        let url = kHostURL + "users"

        Alamofire.request(.POST, url, parameters: params, encoding: .JSON, headers: [ "Content-Type" : "application/json" ]).responseJSON { response in
                if response.result.isSuccess {
                    if let json = response.result.value {
                        if let accessToken = json["access_token"] as? String {
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setObject(accessToken, forKey: "userAccessToken")
                            userDefaults.setObject("Authorization: \(accessToken)", forKey: "header")
                            userDefaults.synchronize()
                            print(userDefaults.objectForKey("header"))                            
                        }
                    }
                } else {
                    JDStatusBarNotification.showWithStatus("ユーザ登録ができませんでした", dismissAfter: 3, styleName: "style")
                }
        }
    }

    func postUserImage(userImage: UIImage) {
        let url = kHostURL + "users/upload"
        
        Alamofire.upload(.POST, url, headers: headers, multipartFormData: {
            (multipartFormData: MultipartFormData) -> Void in
            multipartFormData.appendBodyPart(data: UIImageJPEGRepresentation(userImage, 0.0)!, name: "image")
            }) { (encodingResult: Manager.MultipartFormDataEncodingResult) -> Void in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        if let json = response.result.value {
                            print(JSON(json))
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
            }
        }
    }

    
    // MARK: FinTech API's Router

    enum Router: URLRequestConvertible {
        static let baseURLString = "https://demo-ap08-prod.apigee.net/v1"
        static var OAuthToken: String?

        case ReadUser()
        case Transfer(String, [String: AnyObject])

        var method: Alamofire.Method {
            switch self {
            case .ReadUser:
                return .GET
            case .Transfer:
                return .POST
            }
        }

        var path: String {
            switch self {
            case .ReadUser():
                return "/users/me"
            case .Transfer(let myAccountId, _):
                return "/accounts/\(myAccountId)/transfers"
            }
        }

        // MARK: URLRequestConvertible

        var URLRequest: NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue

            let userDefaults = NSUserDefaults.standardUserDefaults()
            if let token = userDefaults.objectForKey("mufgAccessToken") {
                print("accessToken = \(token)")
                mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            switch self {
            case .Transfer(_, let parameters):
                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
            }
        }
    }


    func startOAuth2Login() {
        let authPath:String = "https://demo-ap08-prod.apigee.net/oauth/authorize?client_id=m2btDuFAaemSKgrbYOKk8mTifi3KWWW4&response_type=token&redirect_uri=paytter://dummy".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if let authURL:NSURL = NSURL(string: authPath)
        {
            UIApplication.sharedApplication().openURL(authURL)
        }
    }

    func processOAuthResponse(url: NSURL) {
        let query = url.absoluteString.componentsSeparatedByString("#")

        let userDefaults = NSUserDefaults.standardUserDefaults()

        // 厳密にやっちゃったけどここまでする必要はありません笑
        if (query.count >= 2) {
            let params = query[1].componentsSeparatedByString("&")
            if (params.count >= 2) {
                for param in params {
                    let pair = param.componentsSeparatedByString("=")
                    if (pair.count >= 2) {
                        if (pair[0] == "access_token") {
                            userDefaults.setObject(pair[1], forKey: "mufgAccessToken")
                            userDefaults.synchronize()
                        }
                    }
                }
            }
        }
    }

    func getUserProfile(callback: (AnyObject?) -> Void) {
        Alamofire.request(APIManager.Router.ReadUser()).responseJSON(completionHandler: { response in
            if (response.result.isSuccess) {
                let result = response.result.value
                let user = User.init(json: JSON(result!))
                user.save()
                callback(result)
            }
        })
    }
}
