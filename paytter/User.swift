//
//  User.swift
//  paytter
//
//  Created by Yu Kadowaki on 3/13/16.
//  Copyright © 2016 ITF. All rights reserved.
//

import SwiftyJSON

class User {
    var userId: String?
    var name: String?
    var postCode: String?
    var address: String?
    var phoneNumber: String?
    var email: String?
    var account: Account?

    init(json: JSON) {
        userId = json["user_id"].string
        name = json["user_name"].string
        postCode = json["post_code"].string
        address = json["address"].string
        phoneNumber = json["phone_number"].string
        email = json["email"].string
        let accountArray = json["my_accounts"].array

        account = Account.getAccount((accountArray?.first)!)
    }

    init() {
    }

    class Account {
        var accountId: String?
        var branchNumber: String?
        var accountTypeCd: String?
        var accountType: String?
        var accountNumber: String?
        var accountHolderTypeCd: String?
        var accountHolderType: String?
        var balance: Int?
        var openingDate: String?

        init(json: JSON) {
            accountId = json["account_id"].string
            branchNumber = json["branch_number"].string
            accountTypeCd = json["account_type_cd"].string
            accountType = json["account_type"].string
            accountNumber = json["account_number"].string
            accountHolderTypeCd = json["account_holder_type_cd"].string
            accountHolderType = json["account_holder_type"].string
            balance = json["balance"].int
            openingDate = json["opening_date"].string
        }

        class func getAccount(json: JSON) -> Account {
            let account = Account(json: json)
            return account
        }

        func save() {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(accountId, forKey: "accountId")
            userDefaults.setObject(branchNumber, forKey: "branchNumber")
            userDefaults.setObject(accountTypeCd, forKey: "accountTypeCd")
            userDefaults.setObject(accountType, forKey: "accountType")
            userDefaults.setObject(accountNumber, forKey: "accountNumber")
            userDefaults.setObject(accountHolderTypeCd, forKey: "accountHolderTypeCd")
            userDefaults.setObject(accountHolderType, forKey: "accountHolderType")
            userDefaults.setObject(balance, forKey: "balance")
            userDefaults.setObject(openingDate, forKey: "openingDate")
            userDefaults.synchronize()
        }
    }

    func save() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(userId, forKey: "userId")
        userDefaults.setObject(name, forKey: "userName")
        userDefaults.setObject(postCode, forKey: "postCode")
        userDefaults.setObject(address, forKey: "address")
        userDefaults.setObject(phoneNumber, forKey: "phoneNumber")
        userDefaults.setObject(email, forKey: "email")
        userDefaults.synchronize()
    }

    class func find() -> User {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let user = User()
        user.userId = userDefaults.objectForKey("userId") as? String
        user.name = userDefaults.objectForKey("userName") as? String
        user.postCode = userDefaults.objectForKey("postCode") as? String
        user.address = userDefaults.objectForKey("address") as? String
        user.phoneNumber = userDefaults.objectForKey("phoneNumber") as? String
        user.email = userDefaults.objectForKey("email") as? String
        return user
    }

}
