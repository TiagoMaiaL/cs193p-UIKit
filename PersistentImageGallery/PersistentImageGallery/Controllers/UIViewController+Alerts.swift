//
//  UIViewController+Alerts.swift
//  PersistentImageGallery
//
//  Created by Tiago Maia Lopes on 11/04/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// Adds alert capabilities to all view controllers.
extension UIViewController {
  
  // MARK: - Factories
  
  /// Returns an alert controller with the passed title and message.
  func makeAlertWith(title: String, message: String) -> UIAlertController {
    return UIAlertController(title: title, message: message, preferredStyle: .alert)
  }
  
  // MARK: - Imperatives
  
  /// Presents a warning alert with the provided title and message.
  func presentWarningWith(title: String, message: String, handler: Optional<() -> ()> = nil) {
    let alert = makeAlertWith(title: title, message: message)
    _ = alert.addActionWith(title: "Ok", style: .default)
    
    present(alert, animated: true, completion: handler)
  }
}

extension UIAlertController {
  
  // MARK: - Imperatives
  
  /// Adds a new alert action to the alert controller.
  func addActionWith(title: String, style: UIAlertActionStyle = .default, handler: Optional<(UIAlertAction) -> Swift.Void> = nil) -> UIAlertAction {
    let action = UIAlertAction(title: title, style: style, handler: handler)
    addAction(action)
    
    return action
  }
}
