//
//  ScanNavigationController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

final class ScanNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        let cartImage = UIImage.fontAwesomeIconWithName(.ShoppingCart, textColor: UIColor.whiteColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        let cartButton = UIBarButtonItem(image: cartImage, style: .Plain, target: self, action: "didTouchCartButton:")

        let userImage = UIImage.fontAwesomeIconWithName(.User, textColor: UIColor.whiteColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        let userButton = UIBarButtonItem(image: userImage, style: .Plain, target: self, action: "didTouchUserButton:")
        
        topViewController?.navigationItem.leftBarButtonItem = cartButton
        topViewController?.navigationItem.rightBarButtonItem = userButton
    }
    
    dynamic private func didTouchCartButton(sender: UIBarButtonItem) {
        print("didTouchCartButton")
    }

    dynamic private func didTouchUserButton(sender: UIBarButtonItem) {
        pushViewController(ViewControllerFactory.myPageViewController(), animated: true)
    }
}
