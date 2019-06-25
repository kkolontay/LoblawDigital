//
//  UIVievController+AlertMessage.swift
//  LoblawDigital
//
//  Created by kkolontay on 6/24/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert( message: String) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    DispatchQueue.main.async {
      self.present(alert, animated: true, completion: nil)
    }
  }
}
