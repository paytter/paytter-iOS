//
//  CartViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    private var products = [Product]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalPriceLabel: UILabel! {
        didSet {
            totalPriceLabel.text = "0円"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.topViewController?.title = "商品確認"
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CartItemCell.kIdentifier, forIndexPath: indexPath) as! CartItemCell
        cell.configure(product: products[indexPath.row])
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        presentViewController(ViewControllerFactory.cartItemDetailViewController(), animated: true, completion: nil)
    }
}