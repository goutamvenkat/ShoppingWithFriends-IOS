//
//  AppDelegate.swift
//  ShoppingWithFriends
//
//  Created by Venkatramanan, Goutam on 4/11/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        Parse.setApplicationId("xnRG7E5e4NJdotEwXwxw756i2jclVNDEntRcRSdV",
            clientKey: "lFm5wKaTg1dZ0sH6jUgLYa7Zo8AK2HkbNX3mRCjD")
        PFTwitterUtils.initializeWithConsumerKey("I4SFlk8NiT6cJwxM79t197AFi", consumerSecret: "PORswlTOQdpjStmMa6h03KKVwPRrio4mXVEYHNe8V0omfB7qio")
//        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        return true
    }
//    func application(application: UIApplication,
//        openURL url: NSURL,
//        sourceApplication: String?,
//        annotation: AnyObject?) -> Bool {
//            return FBSDKApplicationDelegate.sharedInstance().application(application,
//                openURL: url,
//                sourceApplication: sourceApplication,
//                annotation: annotation)
//    }
    
    func applicationDidBecomeActive(application: UIApplication) {
//        FBSDKAppEvents.activateApp()
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

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

