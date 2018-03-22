//
//  GalleryDisplayCollectionViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class GalleryDisplayCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  // MARK: Properties
  
  /// The gallery to be displayed.
  var gallery: ImageGallery! {
    didSet {
      title = gallery.title
      collectionView?.reloadData()
    }
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Navigation
   
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: prepare the detail controller.
  }
  
  // MARK: UICollectionViewDataSource
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery?.images.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    if let imageCell = cell as? ImageCollectionViewCell {
      var galleryImage = gallery.images[indexPath.item]
      imageCell.isLoading = true

      // Code to download the image.
      URLSession(configuration: .default).dataTask(with: galleryImage.imagePath, completionHandler: { (data, response, error) in
        DispatchQueue.main.async {
          if let data = data, let image = UIImage(data: data) {
            imageCell.imageView.image = image

            if let cgImage = image.cgImage {
              let imageHeight = cgImage.height
              let imageWidth = cgImage.width
              
              galleryImage.aspectRatio = Double(imageWidth / imageHeight)
              self.gallery.images[indexPath.item] = galleryImage
            }
          }
          imageCell.isLoading = false
        }
      }).resume()
    
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let galleryImage = gallery.images[indexPath.item]
    let itemWidth: Double = 200 // TODO: Change this later on.
    let defaultItemHeight: Double = 300
    
    if galleryImage.aspectRatio > 0 {
      let itemHeight = itemWidth / galleryImage.aspectRatio
      return CGSize(width: itemWidth, height: itemHeight)
    } else {
      return CGSize(width: itemWidth, height: defaultItemHeight)
    }
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
  
}
