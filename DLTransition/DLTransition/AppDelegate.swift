//
//  AppDelegate.swift
//  DLTransition
//
//  Created by xiangkai yin on 16/7/11.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        DLTransition.validatePanBackWithDLTransitionGestureRecognizerType(.DLTransitionGestureRecognizerEdgePan)
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let navBarColor = UIColor.init(red: 0.063, green: 0.263, blue: 0.455, alpha: 1.0)
        let navBarTintColor = UIColor.whiteColor()
        
        UINavigationBar.appearance().tintColor = navBarTintColor
        UINavigationBar.appearance().barTintColor = navBarColor
        
        let attributes = NSMutableDictionary.init(capacity: 0)
        attributes.setValue(UIFont.boldSystemFontOfSize(18.0), forKeyPath: NSFontAttributeName)
        attributes.setValue(navBarTintColor, forKeyPath: NSForegroundColorAttributeName)
        
        let shadow = NSShadow.init()
        shadow.shadowColor = UIColor.clearColor()
        attributes.setValue(shadow, forKeyPath: NSShadowAttributeName)
        UINavigationBar.appearance().titleTextAttributes = attributes as NSDictionary as? [String : AnyObject]
        
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


}

