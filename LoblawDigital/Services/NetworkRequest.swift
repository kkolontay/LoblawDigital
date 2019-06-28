  //
  //  NetworkRequest.swift
  //  LoblawDigital
  //
  //  Created by kkolontay on 6/24/19.
  //  Copyright © 2019 com.kkolontay. All rights reserved.
  //
  
  import Foundation
  
  
  enum StringURLRequest: String {
    
    case host = "https://www.reddit.com/"
    
    static func fetchSwiftNews() -> String {
      return StringURLRequest.host.rawValue + "r/swift.json"
    }
  }
  
  
  class NetworkRequests: AsyncOperation {
    
    private var handler: ((Data?, String?) -> Void)?
    private var url: String?
    private var request: URLRequest?
    
    init(_ url: String, count: Int?, after: String?,  handler: @escaping (Data?, String?) -> Void) {
      super.init()
      self.handler = handler
      self.url = url
      request = createURLRequest(url, count: count, after: after)
    }
    
    
    
    override func main() {
      
      print(request?.url?.absoluteURL)
      if let request = self.request {
        URLSession.shared.dataTask(with: request) {
          [weak self] data, response, error in
          if self?.isCancelled  ?? false {
            self?.state = .Finished
            return
          }
          if error != nil {
            if (self?.isCancelled ?? false) {return}
            self?.handler?(nil, error?.localizedDescription)
            self?.state = .Finished
            return
          }
          if let responseCode = (response as? HTTPURLResponse)?.statusCode {
            if  200 ... 299 ~= responseCode, let data = data {
              self?.handler?(data, nil)
              
            } else {
              
              self?.handler?(nil, "Error \((response as? HTTPURLResponse)?.statusCode ?? 0)")
              
            }
            self?.state = .Finished
          }
          }.resume()
      }
    }
    
    
    private func createURLRequest(_ url: String, count: Int?, after: String?) -> URLRequest? {
      if count != nil && after != nil {
        let urlComponents = url + "?"
        var components = URLComponents(string: urlComponents)
        let countQueryItem = URLQueryItem(name: "count", value: "\(count!)")
        components?.queryItems?.append(countQueryItem)
        let afterQueryItem = URLQueryItem(name:"after", value: after!)
        components?.queryItems?.append(afterQueryItem)
        guard let urlRequest = components?.url else { return nil}
        return URLRequest(url: urlRequest)
      } else {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
      }
      
      
    }
  }
