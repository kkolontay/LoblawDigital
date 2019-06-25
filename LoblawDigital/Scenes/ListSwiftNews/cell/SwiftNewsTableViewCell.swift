//
//  SwiftNewsTableViewCell.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class SwiftNewsTableViewCell: UITableViewCell {
  @IBOutlet private var storyImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet weak var titleLabelLeadConstraing: NSLayoutConstraint!
 
  
  override func prepareForReuse() {
    storyImageView.image = nil
    titleLabel.text = ""
  }
  
  func setData( title: String) {
    titleLabel.text = title
  }
  
  func setImage( image: UIImage?) {
    storyImageView.image = image
    if image == nil {
      storyImageView.isHidden = true
      titleLabelLeadConstraing.constant = 16
    } else {
      storyImageView.isHidden = false
      if UIDevice.current.userInterfaceIdiom == .pad {
        titleLabelLeadConstraing.constant = 234
      } else {
         titleLabelLeadConstraing.constant = 132
      }
    }
      self.layoutIfNeeded()
  }

}
