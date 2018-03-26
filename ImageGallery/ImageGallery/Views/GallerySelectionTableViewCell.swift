//
//  GallerySelectionTableViewCell.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 26/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class GallerySelectionTableViewCell: UITableViewCell, UITextFieldDelegate {

  // MARK: - Properties
  
  /// The text field used to edit the title's row.
  @IBOutlet weak var titleTextField: UITextField! {
    didSet {
      titleTextField.addTarget(self,
                               action: #selector(titleDidChange(_:)),
                               for: .editingDidEnd)
      titleTextField.returnKeyType = .done
      titleTextField.delegate = self
    }
  }
  
  /// The row's title.
  var title: String {
    set {
      titleTextField?.text = newValue
    }
    get {
      return titleTextField.text ?? ""
    }
  }
  
  // MARK: - Actions
  
  @objc func titleDidChange(_ sender: UITextField) {
    // TODO: Call the delegate.
    print(sender.text ?? "")
  }
  
  // MARK: - Text field delegate
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
