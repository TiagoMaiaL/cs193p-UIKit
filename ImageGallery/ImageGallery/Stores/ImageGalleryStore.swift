//
//  ImageGalleryStore.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 24/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import Foundation

/// The class responsible for managing each gallery model.
struct ImageGalleryStore {
  
  // MARK: - Properties
  
  /// The available image galleries.
  private(set) var galleries = [ImageGallery]()
  
  /// The deleted galleries.
  private(set) var deletedGalleries = [ImageGallery]()
  
  // MARK: - Initializer
  
  init() {
    if galleries.isEmpty {
      // Creates an empty gallery
      galleries.append(ImageGallery(images: [], title: "Empty 1"))
    }
  }
  
  // MARK: - Imperatives
  
  /// Adds a new gallery into the store.
  mutating func addGallery(_ gallery: ImageGallery) {
    galleries.append(gallery)
  }
  
  /// Updates the passed gallery into the store.
  mutating func updateGallery(_ gallery: ImageGallery) {
    if let galleryIndex = galleries.index(of: gallery) {
      galleries[galleryIndex] = gallery
    }
  }
  
  /// Removes the gallery from the stored ones.
  /// If the passed gallery is already deleted,
  /// it's permanently removed from the store.
  mutating func removeGallery(_ gallery: ImageGallery) {
    if let galleryIndex = galleries.index(of: gallery) {
      deletedGalleries.append(galleries.remove(at: galleryIndex))

    } else if let deletedGalleryIndex = deletedGalleries.index(of: gallery) {
      deletedGalleries.remove(at: deletedGalleryIndex)
    }
  }
  
}
