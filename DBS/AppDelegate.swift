//
//  AppDelegate.swift
//  DBS
//
//  Created by SDG on 20/9/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//
 
import UIKit
import AVFoundation
 
var EventsArray = [events]()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Application did finish launching")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.homePage()
        var initialVC = UIViewController()
        
        if shortcutItem.type == "hk.edu.dbs.cl.DBS.timetable" {
            initialVC = storyboard.instantiateViewController(withIdentifier: "Timetable") as! timetableViewController
            
        } else if shortcutItem.type == "hk.edu.dbs.cl.DBS.calendar" {
            initialVC = storyboard.instantiateViewController(withIdentifier: "All Events") as! AllEventsTableViewController as UIViewController
            
        } else if shortcutItem.type == "hk.edu.dbs.cl.DBS.schoolrules" {
            initialVC = storyboard.instantiateViewController(withIdentifier: "School Rules") as! SchoolRulesViewController
            
        }
        let navigationC = UINavigationController(rootViewController: initialVC)
        initialVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "HomeButtonIcon8"), style: .plain, target: self, action: #selector(self.homePage))
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationC
        self.window?.makeKeyAndVisible()
        
//        let root = UIApplication.shared.keyWindow?.rootViewController
//        let firstVC = storyboard.instantiateInitialViewController()
//        root?.present(firstVC!, animated: false, completion: { () -> Void in
//            completionHandler(true)
//        })
    }

    func homePage() {
        UIApplication.shared.keyWindow?.rootViewController?.present(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!, animated: true)
    }
    
}

