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

    func getUserProfile() {
        Alamofire.request(APIManager.Router.ReadUser()).responseJSON(completionHandler: { response in
            if (response.result.isSuccess) {
                let result = response.result.value
                let user = User.init(json: JSON(result!))
                user.save()
            }
        })
    }
}
