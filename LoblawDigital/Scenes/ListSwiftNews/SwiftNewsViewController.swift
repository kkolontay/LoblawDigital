//  
//  SwiftNewsView.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class SwiftNewsViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  private var viewModel: SwiftNewsViewProtocol?
  private var activityIndicator: UIActivityIndicatorView?
  private var isMoreNews = false
  typealias ResultRequest = (([SwiftNewsModel], Bool) -> Void)
  private var resultRequst: ResultRequest?
  
  private var swiftNews:[SwiftNewsModel]? = [] {
    didSet {
      if swiftNews != nil {
        tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = SwiftNewsViewModel()
    initActivityIndicatory()
    resultRequst =  {[weak self] (news, isMore) in
      DispatchQueue.main.async {
        self?.isMoreNews = isMore
        self?.swiftNews = (self?.swiftNews ?? []) + news
        self?.activityIndicator?.stopAnimating()
      }
      
    }
  }
  
  func initActivityIndicatory() {
    activityIndicator = UIActivityIndicatorView()
    activityIndicator?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    activityIndicator?.center = self.view.center
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.style = .gray
    tableView.addSubview(activityIndicator!)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.title = "Swift News"
    activityIndicator?.startAnimating()
    viewModel?.fetchNews( news: resultRequst!, errorMessage: {[weak self] (error) in
        self?.showAlert(message: error)
        self?.activityIndicator?.stopAnimating()
    })
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detailNews" {
     guard let index = sender as? Int else { return}
      guard let controller = segue.destination as? DetailNewsViewController else { return }
      if let news = swiftNews?[index] {
        controller.setNews(news)
      }
    }
  }
  
}

extension SwiftNewsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return swiftNews?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwiftNewsTableViewCell
    if let item = swiftNews?[indexPath.row] {
      cell.setData(title: item.title ?? "")
      if (swiftNews?[indexPath.row].thumbnail != nil) && (swiftNews?[indexPath.row].thumbnail?.count ?? 0) > 7 {
        viewModel?.imageForNews(url: (swiftNews?[indexPath.row].thumbnail)!, imageCell: {[weak cell] (image) in
          DispatchQueue.main.async {
            cell?.setImage(image: image)
          }
        })
      } else {
        cell.setImage(image: nil)
      }
      
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == (swiftNews?.count ?? 0) - 4 && isMoreNews {
      viewModel?.fetchNews( news: resultRequst!, errorMessage: {[weak self] (error) in
        self?.showAlert(message: error)
        self?.activityIndicator?.stopAnimating()
      })
    }
  }
  
  func tableView(_: UITableView, didSelectRowAt: IndexPath) {
    performSegue(withIdentifier: "detailNews", sender: didSelectRowAt.row)
  }
  
  func tableView(_: UITableView, heightForRowAt: IndexPath) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
      return 204.0
    } else {
      return 104.0
    }
  }
  
  func tableView(_: UITableView, didEndDisplaying: UITableViewCell, forRowAt: IndexPath) {
    if let item = swiftNews?[forRowAt.row] {
      viewModel?.cancelImageDownloading(url: item.thumbnail ?? "")
    }
  }
}


