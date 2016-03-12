//
//  MyPageViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var authButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.topViewController?.title = "マイページ"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserInterface", name: UIApplicationDidBecomeActiveNotification, object: nil)
        updateUserInterface()
    }

    @IBAction func authenticate(sender: UIButton) {
        APIManager.sharedManager.startOAuth2Login()
    }

    func updateUserInterface() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let myAccountId = userDefaults.objectForKey("mufgAccessToken") as? String {
            authButton.hidden = true
        }
    }

}
