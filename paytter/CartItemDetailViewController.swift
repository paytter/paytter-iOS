//
//  CartItemDetailViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class CartItemDetailViewController: UIViewController {

    private var price = 0 {
        didSet {
            if basePrice != 0 {
                priceLabel.text = "\(price)円"
                quantityLabel.text = "\(price / basePrice)個"
            }
        }
    }
    private var basePrice = 0
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel! {
        didSet {
            priceLabel.text = "\(price)円"
        }
    }
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton! {
        didSet {
            closeButton.setTitle(Icon.kClose, forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTouchCancelButton(sender: UIButton) {
        print("didTouchCancelButton")
    }
    
    @IBAction private func didTouchStepper(sender: UIStepper) {
        price = basePrice * Int(sender.value)
    }
    
    @IBAction private func didTouchOutView(sender: UITapGestureRecognizer!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTouchCloseButton(sender: UITapGestureRecognizer!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CartItemDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer.view != touch.view {
            return false
        }
        
        return true
    }
}
