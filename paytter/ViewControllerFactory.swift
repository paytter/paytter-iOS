//
//  ViewControllerFactory.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit

final class ViewControllerFactory: NSObject {
    
    private enum StoryboardName: String {
        case Scan = "Scan"
        case Cart = "Cart"
        case MyPage = "MyPage"
    }
    
    enum ScanClassName: String {
        case ScanTabBarController = "ScanTabBarController"
        case ScanNavigationController = "ScanNavigationController"
        case BarcodeScanViewController = "BarcodeScanViewController"
        case ImageScanViewController = "ImageScanViewController"
        case ScanItemDetailViewController = "ScanItemDetailViewController"
    }
    
    enum CartClassName: String {
        case CartNavigationController = "CartNavigationController"
        case CartViewController = "CartViewController"
        case CartItemDetailViewController = "CartItemDetailViewController"
    }
    
    enum MyPageClassName: String {
        case MyPageNavigationController = "MyPageNavigationController"
        case MyPageViewController = "MyPageViewController"
    }
    
    // MARK: Scan

    class func scanNavigationController() -> UINavigationController {
        let storyboard = UIStoryboard(name: StoryboardName.Scan.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(ScanClassName.ScanNavigationController.rawValue) as! UINavigationController
    }
    
    class func barcodeScanViewController() -> BarcodeScanViewController {
        let storyboard = UIStoryboard(name: StoryboardName.Scan.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(ScanClassName.BarcodeScanViewController.rawValue) as! BarcodeScanViewController
    }
    
    class func imageScanViewController() -> ImageScanViewController {
        let storyboard = UIStoryboard(name: StoryboardName.Scan.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(ScanClassName.ImageScanViewController.rawValue) as! ImageScanViewController
    }
    
    class func scanItemDetailViewController() -> ScanItemDetailViewController {
        let storyboard = UIStoryboard(name: StoryboardName.Scan.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(ScanClassName.ScanItemDetailViewController.rawValue) as! ScanItemDetailViewController
    }
    
    
    // MARK: Cart
    
    class func cartNavigationController() -> UINavigationController {
        let storyboard = UIStoryboard(name: StoryboardName.Cart.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(CartClassName.CartNavigationController.rawValue) as! UINavigationController
    }
    
    class func cartViewController() -> CartViewController {
        let storyboard = UIStoryboard(name: StoryboardName.Cart.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(CartClassName.CartViewController.rawValue) as! CartViewController
    }
    
    class func cartItemDetailViewController() -> CartItemDetailViewController {
        let storyboard = UIStoryboard(name: StoryboardName.Cart.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(CartClassName.CartItemDetailViewController.rawValue) as! CartItemDetailViewController
    }

    
    // MARK: MyPage
    
    class func myPageNavigationController() -> UINavigationController {
        let storyboard = UIStoryboard(name: StoryboardName.MyPage.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(MyPageClassName.MyPageNavigationController.rawValue) as! UINavigationController
    }
    
    class func myPageViewController() -> MyPageViewController {
        let storyboard = UIStoryboard(name: StoryboardName.MyPage.rawValue, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(MyPageClassName.MyPageViewController.rawValue) as! MyPageViewController
    }
}

