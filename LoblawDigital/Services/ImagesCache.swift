//
//  ImagesCache.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

final class ImagesCache {
  static  let shared = ImagesCache()
  var imageCache: NSCache<AnyObject, AnyObject>?
  
  private init() {
    imageCache = NSCache<AnyObject, AnyObject>()
  }
  func cleanCache() {
    imageCache = NSCache<AnyObject, AnyObject>()
  }
}
