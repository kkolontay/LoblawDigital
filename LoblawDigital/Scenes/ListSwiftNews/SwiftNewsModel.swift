//  
//  SwiftNewsModel.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import Foundation


struct SwiftNewsModel: Codable {
  var selftext: String?
  var title: String?
  var thumbnail: String?
}

struct NewsDataModel: Codable {
  var data: SwiftNewsModel?
}

struct ChildrenOwner: Codable {
  var dist: Int?
  var children: [NewsDataModel]?
  var after: String?
}


struct ParentOwner: Codable {
  var data: ChildrenOwner?
}
