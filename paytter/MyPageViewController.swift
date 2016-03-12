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
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

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

        profileImageUpdate()

        if let myAccountId = userDefaults.objectForKey("mufgAccessToken") as? String {
            authButton.hidden = true

            if let userId = userDefaults.objectForKey("userId") as? String {
                let user = User.find()
                userProfileView.hidden = false
                nameLabel.text = user.name
                emailLabel.text = user.email
                
            } else {
                APIManager.sharedManager.getUserProfile()
                let user = User.find()
                userProfileView.hidden = false
                nameLabel.text = user.name
                emailLabel.text = user.email
            }
        }
    }

    func profileImageUpdate() {
        profileImageView.setNeedsLayout()
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2.0
        profileImageView.layer.masksToBounds = true
    }
}
