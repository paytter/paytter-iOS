//
//  CartViewController.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    private var products = Cart.sharedManager.products {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalPriceLabel: UILabel! {
        didSet {
            totalPriceLabel.text = "\(Cart.sharedManager.getTotalPrice())円"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.topViewController?.title = "商品確認"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: 削除API叩く
        products.removeAtIndex(indexPath.row)
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cartItemDetailViewController = ViewControllerFactory.cartItemDetailViewController()
        cartItemDetailViewController.delegate = self
        cartItemDetailViewController.product = products[indexPath.row]
        presentViewController(cartItemDetailViewController, animated: true, completion: nil)
    }
}

extension CartViewController: CartItemDetailViewControllerDelegate {
    func dismissViewController() {
        tableView.reloadData()
    }
}