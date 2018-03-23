//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// Model representing a gallery with it's images.
struct ImageGallery {
  
  /// Model representing a gallery's image.
  struct Image {
    
    // MARK: - Properties
    
    /// The image's URL.
    var imagePath: URL?
    
    /// The image's aspect ratio.
    var aspectRatio: Double
    
    /// The fetched image's data.
    var imageData: Data?
    
    /// MARK: - Initializer
    
    init(imagePath: URL?, aspectRatio: Double) {
      self.imagePath = imagePath
      self.aspectRatio = aspectRatio
    }
  }
  
  // MARK: - Properties
  
  /// The gallery's images.
  var images: [Image]
  
  /// The gallery's title.
  var title: String
  
}
