//
//  ScanItemDetailViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class ScanItemDetailViewController: UIViewController {

    var product: Product?
    private var price = 0 {
        didSet {
            priceLabel.text = "\(price)円"
            product?.price = price
        }
    }
    private var quantity = 0 {
        didSet {
            quantityLabel.text = "\(quantity)個"
            product?.detail?.quantity = quantity.description
            price = (product?.price ?? 0) * quantity
        }
    }
    
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
    @IBOutlet private weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle(Icon.kClose, forState: .Normal)
        }
    }
    @IBOutlet private weak var addButton: UIButton! {
        didSet {
            addButton.setTitle(Icon.kAddCart, forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTouchStepper(sender: UIStepper) {
        quantity = Int(sender.value)
    }
    
    @IBAction private func didTouchOutView(sender: UITapGestureRecognizer!) {
        if let product = product {
            Cart.sharedManager.products.append(product)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTouchCloseButton(sender: UITapGestureRecognizer!) {
        if let product = product {
            Cart.sharedManager.products.append(product)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ScanItemDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer.view != touch.view {
            return false
        }
        
        return true
    }
}
