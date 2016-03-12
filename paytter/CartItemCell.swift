//
//  CartItemCell.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit
import AlamofireImage

class CartItemCell: UITableViewCell {

    static let kIdentifier = "CartItemCell"
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    
    func configure(product product: Product) {
        nameLabel.text = product.detail?.itemName
        quantityLabel.text = product.detail?.quantity
        priceLabel.text = product.price?.description
        productImageView.af_setImageWithURL(NSURL(string: product.imageUrl ?? "")!)
    }
}
