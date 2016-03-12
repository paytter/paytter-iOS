//
//  ImageScanViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class ImageScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.sharedManager.getProduct {
            (product: Product) -> Void in
            let scanItemDetailViewController = ViewControllerFactory.scanItemDetailViewController()
            scanItemDetailViewController.product = product
            self.presentViewController(scanItemDetailViewController, animated: true, completion: nil)
        }
    }
}
