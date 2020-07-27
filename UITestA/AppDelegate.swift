//
//  AppDelegate.swift
//  UITestA
//
//  Created by rickb on 7/27/20.
//  Copyright © 2020 Live Surface. All rights reserved.
//

import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Hacky thing to get rid of separator in list since we're using List to take advantage of lazy loading, in iOS 14 we'd just use lazy grid
		UITableView.appearance(whenContainedInInstancesOf:
			[UIHostingController<ContentView>.self]
		).separatorStyle = .none

		imageService.initialize()
		
		return true
	}

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}
}

func isProduction() -> Bool {
#if DEBUG
	if let production = ProcessInfo.processInfo.environment["isProduction"] {
		return production != "0"
	}
	return false
#else
	return true
#endif
}
let imageService = ImageService(
	manifestURL: "https://www.livesurface.com/test/api/images.php",
	baseImageURL: "https://www.livesurface.com/test/images/",
	apiKey: "79319da5-8cb3-43ac-f5b0-f38a727242a8",
	production: isProduction()
)

