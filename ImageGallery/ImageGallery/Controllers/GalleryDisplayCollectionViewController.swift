//
//  GalleryDisplayCollectionViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class GalleryDisplayCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate, UICollectionViewDragDelegate {

  // MARK: - Properties
  
  /// The galleries' store.
  /// - Note: The store is used to update the current gallery
  ///         every time a new image is added.
  var galleriesStore: ImageGalleryStore?
  
  /// The gallery to be displayed.
  var gallery: ImageGallery! {
    didSet {
      title = gallery?.title
    }
  }
  
  /// The width of each cell in the collection view.
  var itemWidth: CGFloat {
    return ((collectionView?.frame.size.width ?? 0) / 2) - 25
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func loadView() {
    super.loadView()
    collectionView!.dragDelegate = self
    collectionView!.dropDelegate = self
  }
  
  // MARK: - Navigation
   
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? ImageDisplayViewController {
      let cell = sender as! UICollectionViewCell
      if let indexPath = collectionView?.indexPath(for: cell) {
        let selectedImage = getImage(at: indexPath)
        destination.image = selectedImage
      }
    }
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
    
    guard let galleryImage = getImage(at: indexPath) else {
      return cell
    }
    
    if let imageCell = cell as? ImageCollectionViewCell {
      if let data = galleryImage.imageData, let image = UIImage(data: data) {
        imageCell.imageView.image = image
        imageCell.isLoading = false
      } else {
        imageCell.isLoading = true
      }
    }
    
    return cell
  }
  
  // MARK: - Flow layout delegate
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let galleryImage = gallery.images[indexPath.item]
    let itemHeight = itemWidth / CGFloat(galleryImage.aspectRatio)
    
    return CGSize(width: itemWidth, height: itemHeight)
  }
  
  // MARK: - Collection view drag delegate
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    session.localContext = collectionView
    return getDragItems(at: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
    return getDragItems(at: indexPath)
  }
  
  private func getDragItems(at indexPath: IndexPath) -> [UIDragItem] {
    var dragItems = [UIDragItem]()
    
    if let galleryImage = getImage(at: indexPath) {
      if let imageURL = galleryImage.imagePath as NSURL? {
        let urlItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL))
        urlItem.localObject = galleryImage
        dragItems.append(urlItem)
      }
    }
    
    return dragItems
  }
  
  // MARK: - Collection view drop delegate
  
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
    if collectionView.hasActiveDrag {
      // if the drag is from this collection view, the image isn't needed.
      return session.canLoadObjects(ofClass: URL.self)
    } else {
      return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      dropSessionDidUpdate session: UIDropSession,
                      withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
    // Determines if the drag was initiated from this app, in case of reordering.
    let isDragFromThisApp = (session.localDragSession?.localContext as? UICollectionView) == collectionView
    
    return UICollectionViewDropProposal(operation: isDragFromThisApp ? .move : .copy, intent: .insertAtDestinationIndexPath)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    performDropWith coordinator: UICollectionViewDropCoordinator
  ) {
    let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
    
    for item in coordinator.items {
      if let sourceIndexPath = item.sourceIndexPath {
        // The drag was initiated from this collection view.
        if let galleryImage = item.dragItem.localObject as? ImageGallery.Image {
          collectionView.performBatchUpdates({
            self.gallery.images.remove(at: sourceIndexPath.item)
            self.gallery.images.insert(galleryImage, at: destinationIndexPath.item)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
          })
          coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
      } else {
        // The drag was initiated from outside of the app.
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
        // TODO: Check if it's possible to add the placeholder only after figuring out what's the aspect ratio.
        _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){ (provider, error) in
          DispatchQueue.main.async {
            if let image = provider as? UIImage {
              self.gallery.images[destinationIndexPath.item].aspectRatio = image.aspectRatio
              placeholderContext.setNeedsCellUpdate()
            }
          }
        }
        
        // Loads the URL.
        _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
          if let url = provider?.imageURL {
            self.gallery.images[destinationIndexPath.item].imagePath = url
            
            // Downloads the image from the fetched url.
            URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
              DispatchQueue.main.async {
                if let data = data {
                  placeholderContext.commitInsertion {
                    self.gallery.images[$0.item].imageData = data
                  }
                } else {
                  // There was an error. Remove the placeholder.
                  placeholderContext.deletePlaceholder()
                }
              }
            }.resume()
          }
        }
        
      }

    }
  }
  
}
