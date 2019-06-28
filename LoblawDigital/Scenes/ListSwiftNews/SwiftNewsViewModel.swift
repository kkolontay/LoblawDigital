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
  private var isNextPage: String?
  private var countInPage: Int?

  init(withSwiftNews serviceProtocol: SwiftNewsServiceProtocol = SwiftNewsService() ) {
    self.service = serviceProtocol
    isNextPage = ""
  }

}

extension SwiftNewsViewModel: SwiftNewsViewProtocol {
  func fetchNews( news: @escaping (([SwiftNewsModel], Bool) -> Void), errorMessage: @escaping ((String) -> Void)) {
    service.fetchData(count: self.countInPage, nextPage: isNextPage, success: { (swiftNews) in
      if self.isNextPage == nil {
        news([], false)
        return
      }
        self.isNextPage = swiftNews.data?.after
        self.countInPage = swiftNews.data?.dist
  
     guard let newsArray = swiftNews.data?.children?.compactMap({ (item) -> SwiftNewsModel? in
        return item.data
     }) else {return}
      news(newsArray, self.isNextPage != nil)
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
  func fetchNews( news: @escaping (([SwiftNewsModel], Bool) -> Void), errorMessage: @escaping ((String) -> Void))
  func imageForNews(url: String, imageCell: @escaping ((UIImage?) -> Void))
  func cancelImageDownloading(url:String)
}
