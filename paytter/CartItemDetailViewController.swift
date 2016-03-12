//
//  CartItemDetailViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class CartItemDetailViewController: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTouchCancelButton(sender: UIButton) {
        print("didTouchCancelButton")
    }
    
    @IBAction private func didTouchStepper(sender: UIStepper) {
        print("didTouchStepper")
    }
}
