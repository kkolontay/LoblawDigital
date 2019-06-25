//  
//  SwiftNewsViewModel.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class SwiftNewsViewModel {

  private let service: SwiftNewsServiceProtocol

  init(withSwiftNews serviceProtocol: SwiftNewsServiceProtocol = SwiftNewsService() ) {
    self.service = serviceProtocol
  }

}

extension SwiftNewsViewModel: SwiftNewsViewProtocol {
  func fetchNews(news: @escaping (([SwiftNewsModel]) -> Void), errorMessage: @escaping ((String) -> Void)) {
    service.fetchData(success: { (swiftNews) in
      let newsArray = swiftNews.map({ (item) -> SwiftNewsModel in
        return item.data
      })
      news(newsArray)
    }) { (error) in
      errorMessage(error)
    }
  }
  
  func imageForNews(url: String, imageCell: @escaping ((UIImage?) -> Void)) {
    service.downloadImage(url: url) { (image) in
      imageCell(image)
    }
  }
  
  func cancelImageDownloading(url: String) {
    service.cancelRequest(url: url)
  }

}

protocol SwiftNewsViewProtocol: AnyObject {
  func fetchNews(news: @escaping (([SwiftNewsModel]) -> Void), errorMessage: @escaping ((String) -> Void))
  func imageForNews(url: String, imageCell: @escaping ((UIImage?) -> Void))
  func cancelImageDownloading(url:String)
}
