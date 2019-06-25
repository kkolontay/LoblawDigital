//
//  Download.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation

class Download {
  var url: String
  var task: Operation
  var isDownloading: Bool
  
  init(url: String, task: Operation, isDownloading: Bool) {
    self.url = url
    self.task = task
    self.isDownloading = isDownloading
  }
}
