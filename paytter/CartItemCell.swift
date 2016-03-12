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
        quantityLabel.text = "\(product.detail?.quantity?.description ?? "")個"
        priceLabel.text = "\((product.price ?? 0) * (product.detail?.quantity ?? 0))円"
        if let url = NSURL(string: product.imageUrl ?? "") {
            productImageView.af_setImageWithURL(url)
        }
    }
}
