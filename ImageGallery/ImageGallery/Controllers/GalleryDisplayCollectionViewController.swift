//
//  GalleryDisplayCollectionViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class GalleryDisplayCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate {

  // MARK: Properties
  
  /// The gallery to be displayed.
  var gallery: ImageGallery! {
    didSet {
      title = gallery?.title
      collectionView?.reloadData()
    }
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func loadView() {
    super.loadView()
    collectionView?.dropDelegate = self
  }
  
  // MARK: - Navigation
   
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // TODO: prepare the detail controller.
  }
  
  // MARK: - Imperatives
  
  /// Returns the image at the provided indexPath.
  private func getImage(at indexPath: IndexPath) -> ImageGallery.Image? {
    return gallery?.images[indexPath.item]
  }
  
  /// Inserts the provided image at the provided indexPath.
  private func insertImage(_ image: ImageGallery.Image, at indexPath: IndexPath) {
    gallery?.images.insert(image, at: indexPath.item)
  }
  
  // MARK: - Collection view data source
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery?.images.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    if let imageCell = cell as? ImageCollectionViewCell,
       let galleryImage = getImage(at: indexPath) {
      imageCell.isLoading = true

      if imageCell.imageView.image == nil, galleryImage.imagePath != nil {
        // Code to download the image.
        URLSession(configuration: .default).dataTask(with: galleryImage.imagePath!.imageURL, completionHandler: { (data, response, error) in
          DispatchQueue.main.async {
            if let data = data, let image = UIImage(data: data) {
              imageCell.imageView.image = image
            }
            imageCell.isLoading = false
          }
        }).resume()
      }

    }
    
    return cell
  }
  
  // MARK: - Flow layout delegate
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let galleryImage = gallery.images[indexPath.item]
    let itemWidth: Double = 200 // TODO: Change this to be besed on the width of the collection view scrollable width.
    let defaultItemHeight: Double = 300
    
    if galleryImage.aspectRatio > 0 {
      let itemHeight = itemWidth / galleryImage.aspectRatio
      return CGSize(width: itemWidth, height: itemHeight)
    } else {
      return CGSize(width: itemWidth, height: defaultItemHeight)
    }
  }
  
  // MARK: - Collection view drop delegate
  
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      dropSessionDidUpdate session: UIDropSession,
                      withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
    return UICollectionViewDropProposal(
      operation: .copy,
      intent: .insertAtDestinationIndexPath
    )
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      performDropWith coordinator: UICollectionViewDropCoordinator) {
    // For now it's only going to accept drops from outside the app.
    if let item = coordinator.items.last {
      let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
      
      let placeholderContext = coordinator.drop(
        item.dragItem,
        to: UICollectionViewDropPlaceholder(
          insertionIndexPath: destinationIndexPath,
          reuseIdentifier: reuseIdentifier
        )
      )
      
      // Creates a new image to hold the place for the dragged one.
      let draggedImage = ImageGallery.Image(imagePath: nil, aspectRatio: 1)
      insertImage(draggedImage, at: destinationIndexPath)
      
      // Loads the image.
      _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){ (provider, error) in
        DispatchQueue.main.async {
          if let image = provider as? UIImage {
            self.gallery.images[destinationIndexPath.item].aspectRatio = image.aspectRatio
          }
        }
      }
      
      // Loads the URL.
      _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
        DispatchQueue.main.async {
          if let url = provider {
            // TODO: Set the image url.
            // Request it now?
            placeholderContext.commitInsertion { indexPath in
              self.gallery.images[destinationIndexPath.item].imagePath = url
            }
          } else {
            placeholderContext.deletePlaceholder()
          }
        }
      }
      
      
    }
    
  }
  
}
