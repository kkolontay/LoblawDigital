//
//  DetailNewsViewController.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {
  private var news:SwiftNewsModel?
  private var viewModel: SwiftNewsViewProtocol?
  @IBOutlet weak var nailImageView: UIImageView!
  @IBOutlet weak var newsTextLabel: UILabel!
  @IBOutlet weak var topTextLabelConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = SwiftNewsViewModel()
    let url = news?.thumbnail
    if (url?.count ?? 0) > 7 {
      viewModel?.imageForNews(url: url ?? "", imageCell: {[weak self] (image) in
        DispatchQueue.main.async {
          self?.nailImageView.image = image
          if UIDevice.current.userInterfaceIdiom == .pad {
            self?.topTextLabelConstraint.constant = 340
          } else {
            self?.topTextLabelConstraint.constant = 240
          }
        }
      })
    } else {
      topTextLabelConstraint.constant = 16
    }
    self.title = news?.title
    let textNews = news?.selftext
    if (textNews?.count ?? 0) > 7 {
      newsTextLabel.text = news?.selftext
    } else {
      newsTextLabel.text = news?.title
    }
  }
  
  func setNews(_ swiftNews: SwiftNewsModel) {
    news = swiftNews
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    let url = news?.thumbnail
    if (url?.count ?? 0) > 7 {
      viewModel?.cancelImageDownloading(url: url!)
    }
  }
}
