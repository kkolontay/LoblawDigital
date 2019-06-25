//
//  ImageDownloader.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit
class ImageDownloading: AsyncOperation {
  
  private var request: URLRequest?
  private var handler: ((UIImage?, String) -> Void)?
  
  
  init(_ url: String, handler: @escaping (UIImage?, String) -> (Void)) {
    super.init()
    self.handler = handler
    guard let urlUrl = URL(string: url) else {
      handler(nil, url)
      return
    }
    request = URLRequest(url: urlUrl)
    request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request?.httpMethod = "GET"
  }
  
  
  override func main() {
    
    if let image = ImagesCache.shared.imageCache?.object(forKey: request?.url?.absoluteString as AnyObject) as? UIImage {
      if self.isCancelled {
        return
      }
      self.handler?(image, request?.url?.absoluteString ?? "")
      self.state = .Finished
      return
      
    } else {
      guard let request = request else {
        state = .Finished
        return
      }
      URLSession.shared.dataTask(with: request) {
        [weak self] data, response, error in
        if self?.isCancelled  ?? false {
          
          return
        }
        if error != nil {
          print(error?.localizedDescription ?? "Dowloading error")
          self?.state = .Finished
          return
        }
        if let response = (response as? HTTPURLResponse)?.statusCode {
          if  200 ... 299 ~= response, let data = data {
            if  let image = UIImage(data: data) {
              ImagesCache.shared.imageCache?.setObject(image, forKey: request.url?.absoluteString as AnyObject)
              if self?.isCancelled  ?? false {
                return
              }
              self?.handler?(image, request.url?.absoluteString ?? "")
              
              self?.state = .Finished
            }
          }
        } else {
          if  let statusCode = (response as? HTTPURLResponse)?.statusCode {
            print("Error \(statusCode)")
          }
          self?.state = .Finished
        }
        }.resume()
    }
  }
}
