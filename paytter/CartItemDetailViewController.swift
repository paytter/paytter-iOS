//
//  CartItemDetailViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class CartItemDetailViewController: UIViewController {

    var product: Product?
    var delegate: CartItemDetailViewControllerDelegate?
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton! {
        didSet {
            closeButton.setTitle(Icon.kClose, forState: .Normal)
        }
    }
    @IBOutlet private weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = product?.detail?.itemName
        priceLabel.text = "\((product?.price ?? 0) * (product?.detail?.quantity ?? 0))円"
        quantityLabel.text = "\(product?.detail?.quantity ?? 0)個"
        stepper.value = Double(product?.detail?.quantity ?? 0)
        if let url = NSURL(string: product?.imageUrl ?? "") {
            productImageView.af_setImageWithURL(url)
        }
    }
    
    @IBAction private func didTouchStepper(sender: UIStepper) {
        if (product?.detail?.quantity ?? 0) < Int(sender.value) {
            product?.addItem()
        } else if (product?.detail?.quantity ?? 0) > Int(sender.value) {
            product?.removeItem()
        }
        
        priceLabel.text = "\((product?.price ?? 0) * (product?.detail?.quantity ?? 0))円"
        quantityLabel.text = "\(product?.detail?.quantity ?? 0)個"
    }
    
    @IBAction private func didTouchCancelButton(sender: UIButton) {
        print("didTouchCancelButton")
    }
    
    @IBAction private func didTouchOutView(sender: UITapGestureRecognizer!) {
        delegate?.dismissViewController()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func didTouchCloseButton(sender: UITapGestureRecognizer!) {
        delegate?.dismissViewController()
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

protocol CartItemDetailViewControllerDelegate {
    func dismissViewController()
}