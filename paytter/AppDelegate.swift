//
//  AppDelegate.swift
//  paytter
//
//  Created by Kengo Yokoyama on 2016/03/12.
//  Copyright © 2016年 ITF. All rights reserved.
//

import UIKit
import FontAwesome_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let tabBarController = ViewControllerFactory.mainTabBarController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        configureNavigationBar()
        configureTabbarController()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        APIManager.sharedManager.processOAuthResponse(url)
        return true
    }

    private func configureNavigationBar() {
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backIndicatorImage = UIImage.fontAwesomeIconWithName(.ArrowLeft, textColor: UIColor.whiteColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal).imageWithAlignmentRectInsets(UIEdgeInsetsMake(6, 6, 6, 6))
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage.fontAwesomeIconWithName(.ArrowLeft, textColor: UIColor.whiteColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal).imageWithAlignmentRectInsets(UIEdgeInsetsMake(6, 6, 6, 6))
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -64), forBarMetrics: UIBarMetrics.Default)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.navigationBarColor()], forState: .Selected)
    }
    
    private func configureTabbarController() {
        let rankingNavigationController = ViewControllerFactory.barcodeScanNavigationController()
        rankingNavigationController.tabBarItem.image = UIImage.fontAwesomeIconWithName(.Barcode, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        rankingNavigationController.tabBarItem.selectedImage = UIImage.fontAwesomeIconWithName(.Barcode, textColor: UIColor.navigationBarColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        rankingNavigationController.tabBarItem.title = "バーコード"
        
        let searchNavigationController = ViewControllerFactory.itemScanNavigationController()
        searchNavigationController.tabBarItem.image = UIImage.fontAwesomeIconWithName(.Photo, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        searchNavigationController.tabBarItem.selectedImage = UIImage.fontAwesomeIconWithName(.Photo, textColor: UIColor.navigationBarColor(), size: CGSizeMake(30, 30)).imageWithRenderingMode(.AlwaysOriginal)
        searchNavigationController.tabBarItem.title = "画像"
        
        tabBarController.setViewControllers([rankingNavigationController,
            searchNavigationController], animated: false)
        
        window?.rootViewController = tabBarController
    }
}

