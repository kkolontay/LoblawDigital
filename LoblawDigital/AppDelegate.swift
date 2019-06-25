//
//  AppDelegate.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var cache: ImagesCache?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    cache = ImagesCache.shared
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    if cache != nil {
      cache?.cleanCache()
    }
  }


}

