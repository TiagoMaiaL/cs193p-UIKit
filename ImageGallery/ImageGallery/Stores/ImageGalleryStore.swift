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
  
  /// The keys used to store the models within UserDefaults.
  private struct StorageKeys {
    static let galleries = "gallery"
    static let deletedGalleries = "deleted_galleries"
  }
  
  // MARK: - Properties
  
  /// The available image galleries.
  private(set) var galleries: [ImageGallery] {
    didSet {
      storeGalleries(galleries, at: StorageKeys.galleries)
    }
  }
  
  /// The deleted galleries.
  private(set) var deletedGalleries: [ImageGallery] {
    didSet {
      storeGalleries(deletedGalleries, at: StorageKeys.deletedGalleries)
    }
  }
  
  /// The store's user defaults instance.
  private let userDefaults = UserDefaults.standard
  
  // MARK: - Initializer
  
  init() {
    galleries = []
    deletedGalleries = []
    
    if let storedGalleries = getGalleriesBy(key: StorageKeys.galleries) {
      galleries = storedGalleries
    }

    if let storedDeletedGalleries = getGalleriesBy(key: StorageKeys.deletedGalleries) {
      deletedGalleries = storedDeletedGalleries
    }
    
    if galleries.isEmpty {
      addNewGallery()
    }
  }
  
  // MARK: - Imperatives
  
  /// Tries to access and retrieve the galleries stored at
  /// the specified key in the user defaults.
  private func getGalleriesBy(key: String) -> [ImageGallery]? {
    if let galleriesData = userDefaults.value(forKey: key) as? Data {
      if let galleries = try? JSONDecoder().decode([ImageGallery].self, from: galleriesData) {
        return galleries
      }
    }
    
    return nil
  }
  
  /// Tries to store the passed galleries at the key.
  private func storeGalleries(_ gallery: [ImageGallery], at key: String) {
    do {
      print("calling store")
      try? userDefaults.setValue(
        JSONEncoder().encode(gallery),
        forKey: key
      )
      userDefaults.synchronize()
    }
  }
  
  /// Adds a new gallery into the store.
  mutating func addNewGallery() {
    galleries.insert(makeGallery(), at: 0)
  }
  
  private func makeGallery() -> ImageGallery {
    let galleryNames = (galleries + deletedGalleries).map { gallery in
      return gallery.title
    }
    return ImageGallery(
      images: [],
      title: "Empty".madeUnique(withRespectTo: galleryNames)
    )
  }
  
  /// Updates the passed gallery into the store.
  mutating func updateGallery(_ gallery: ImageGallery) {
    if let galleryIndex = galleries.index(of: gallery) {
      galleries[galleryIndex] = gallery
    }
    
    NotificationCenter.default.post(
      name: Notification.Name.galleryUpdated,
      object: self,
      userInfo: [Notification.Name.galleryUpdated : gallery]
    )
  }
  
  /// Removes the gallery from the stored ones.
  /// If the passed gallery is already deleted,
  /// it's permanently removed from the store.
  mutating func removeGallery(_ gallery: ImageGallery) {
    if let galleryIndex = galleries.index(of: gallery) {
      deletedGalleries.append(galleries.remove(at: galleryIndex))
      if galleries.isEmpty {
        addNewGallery()
      }

      NotificationCenter.default.post(
        name: Notification.Name.galleryDeleted,
        object: self,
        userInfo: [Notification.Name.galleryDeleted : gallery]
      )
    } else if let deletedGalleryIndex = deletedGalleries.index(of: gallery) {
      deletedGalleries.remove(at: deletedGalleryIndex)
    }
  }
  
  /// Recovers the passed gallery, if it's a deleted one.
  mutating func recoverGallery(_ gallery: ImageGallery) {
    if let deletedIndex = deletedGalleries.index(of: gallery) {
      galleries.append(deletedGalleries.remove(at: deletedIndex))
    }
  }
  
}

extension Notification.Name {
  static let galleryUpdated = Notification.Name(rawValue: "galleryUpdated")
  static let galleryDeleted = Notification.Name(rawValue: "galleryDeleted")
}
