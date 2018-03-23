//
//  ImageDisplayViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ImageDisplayViewController: UIViewController {

  // MARK: - Properties
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
  @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
