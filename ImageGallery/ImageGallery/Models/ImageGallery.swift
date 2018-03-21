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
    
    // MARK: Properties
    
    /// The image's URL.
    let imagePath: URL
    
    /// The image's aspect ratio.
    let aspectRatio: Double
  }
  
  // MARK: Properties
  
  /// The gallery's images.
  var images: [Image]
  
  /// The gallery's title.
  var title: String
  
}
