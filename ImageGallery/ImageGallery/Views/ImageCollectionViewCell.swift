//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The cell in charge of displaying a single image of the gallery.
class ImageCollectionViewCell: UICollectionViewCell {

  // MARK: - Properties
  
  /// The cell's image view.
  @IBOutlet weak var imageView: UIImageView!
  
  /// The cell's loading spinner.
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  /// The cell's loading flag.
  var isLoading = false {
    didSet {
      activityIndicator.isHidden = !isLoading
    }
  }
  
  // MARK: - Life cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
//    imageView.image = nil
  }
  
}
