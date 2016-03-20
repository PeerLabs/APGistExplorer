//
//  AppDelegate.swift
//  APGistExplorer
//
//  Created by Abrar Peer on 20/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit
import XCGLogger


//Default Debug Logger

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let log: XCGLogger = {
	// Setup XCGLogger
	let log = XCGLogger.defaultInstance()
	log.xcodeColorsEnabled = false // Or set the XcodeColors environment variable in your scheme to YES
	log.xcodeColors = [
		.Verbose: .lightGrey,
		.Debug: .darkGrey,
		.Info: .darkGreen,
		.Warning: .orange,
		.Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
		.Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
	]
	
	#if USE_NSLOG // Set via Build Settings, under Other Swift Flags
		log.removeLogDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier)
		log.addLogDestination(XCGNSLogDestination(owner: log, identifier: XCGLogger.Constants.nslogDestinationIdentifier))
		log.logAppDetails()
	#else
		let logPath: NSURL = appDelegate.cacheDirectory.URLByAppendingPathComponent("DEBUG_Log.txt")
		log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
	#endif
	
	return log
}()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
	
	var window: UIWindow?
	
	let documentsDirectory: NSURL = {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.endIndex - 1]
	}()
	
	let cacheDirectory: NSURL = {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
		return urls[urls.endIndex - 1]
	}()
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		let splitViewController = self.window!.rootViewController as! UISplitViewController
		let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
		navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
		splitViewController.delegate = self
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
	
	// MARK: - Split view
	
	func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
		guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
		guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
		if topAsDetailController.detailItem == nil {
			// Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
			return true
		}
		return false
	}
	
}

