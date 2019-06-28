//  
//  SwiftNewsService.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit


protocol SwiftNewsServiceProtocol {
  func fetchData(success: @escaping ((ParentOwner) -> Void), errorMessage:@escaping ((String) -> Void))
  func downloadImage(url: String, success: @escaping ((UIImage?) -> Void))
  func cancelRequest(url: String)
}

class SwiftNewsService: SwiftNewsServiceProtocol {
  private let operation: OperationQueue
  private var activeImageDowloading: [String: Download]
  
  init() {
    operation = OperationQueue()
    activeImageDowloading = Dictionary<String, Download>()
  }
  
  func fetchData(success: @escaping ((ParentOwner) -> Void), errorMessage:@escaping ((String) -> Void)) {
    let url = StringURLRequest.fetchSwiftNews()
    let networkRequest = NetworkRequests(url) {
      data, error in
      if error != nil {
        errorMessage(error!)
        return
      }
      if data != nil {
        let decoder = JSONDecoder()
        do {
          
          let object = try decoder.decode(ParentOwner.self, from: data!)
          success(object)
          
        } catch let error as NSError {
          errorMessage(error.localizedDescription)
        }
      }
    }
    operation.addOperation(networkRequest)
  }
  
  func downloadImage(url: String, success: @escaping ((UIImage?) -> Void)) {
    let networkRequest = ImageDownloading(url) {
     [weak self] image, url in
      if let download = self?.activeImageDowloading[url] {
        download.isDownloading = false
      }
      
        self?.activeImageDowloading.removeValue(forKey: url)
      success(image)
    }
    activeImageDowloading[url] = Download(url: url, task: networkRequest, isDownloading: true)
    operation.addOperation(networkRequest)
  }
  
  func cancelRequest(url: String) {
    if let dowloader = activeImageDowloading[url] {
      if dowloader.isDownloading {
        dowloader.task.cancel()
      }
      activeImageDowloading.removeValue(forKey: url)
    }
  }
}
