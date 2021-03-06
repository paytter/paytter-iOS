//
//  ImageScanViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class ImageScanViewController: UIViewController {

    @IBOutlet private weak var rssiLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BeaconScanner.sharedManager.delegate = self        
//        APIManager.sharedManager.getProduct(storeId: 1, eanId: nil, isbnId: nil, itemIds: "food_0000121261", completion: {
//            (product: Product) -> Void in
//            let scanItemDetailViewController = ViewControllerFactory.scanItemDetailViewController()
//            scanItemDetailViewController.product = product
//            self.presentViewController(scanItemDetailViewController, animated: true, completion: nil)
//        })
    }
}

extension ImageScanViewController: BeaconScannerDelegate {
    func didRangeBeacon(rssi rssi: String, distance: String) {
        print(rssi, distance)
        rssiLabel.text = "RSSI: \(rssi)"
        distanceLabel.text = "distance: \(distance)"
    }
}