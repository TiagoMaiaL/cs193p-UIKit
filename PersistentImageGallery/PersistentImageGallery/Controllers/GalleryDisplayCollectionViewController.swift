//
//  GalleryDisplayCollectionViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class GalleryDisplayCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDropDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate, ImageRequestManagerDelegate {
  
  // MARK: - Properties
  
  /// The image request manager used by this controller.
  var imageRequestManager: ImageRequestManager? {
    didSet {
      imageRequestManager?.delegate = self
    }
  }
  
  /// The gallery document being presented by this controller.
  var galleryDocument: ImageGalleryDocument?
  
  /// The gallery to be displayed.
  private var gallery: ImageGallery! {
    didSet {
      title = gallery?.title
      collectionView?.reloadData()
    }
  }
  
  /// The dictionary caching all requested images.
  private var cachedImages = [ImageGallery.Image : UIImage]()
  
  /// The maximum collection view's item width.
  private var maximumItemWidth: CGFloat? {
    return collectionView?.frame.size.width
  }
  
  /// The minimum collection view's item width.
  private var minimumItemWidth: CGFloat? {
    guard let collectionView = collectionView else { return nil }
    return (collectionView.frame.size.width / 2) - 5
  }
  
  /// The width of each cell in the collection view.
  private lazy var itemWidth: CGFloat = {
    return minimumItemWidth ?? 0
  }()
  
  /// The collection view's flow layout.
  private var flowLayout: UICollectionViewFlowLayout? {
    return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  // MARK: - Life Cycle
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func loadView() {
    super.loadView()
    
    collectionView!.dragInteractionEnabled = true
    collectionView!.dragDelegate = self
    collectionView!.dropDelegate = self
    
    flowLayout!.minimumLineSpacing = 5
    flowLayout!.minimumInteritemSpacing = 5
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // In order to implement the drop interaction in the navigation bar button,
    // a custom view had to be added, since a UIBarButtonItem is not a
    // view and doesn't handle interactions.
    let trashButton = UIButton()
    trashButton.setImage(#imageLiteral(resourceName: "icon_trash"), for: .normal)
    
    let dropInteraction = UIDropInteraction(delegate: self)
    trashButton.addInteraction(dropInteraction)
    
    let barItem = UIBarButtonItem(customView: trashButton)
    
    navigationItem.rightBarButtonItem = barItem
    
    barItem.customView!.widthAnchor.constraint(equalToConstant: 25).isActive = true
    barItem.customView!.heightAnchor.constraint(equalToConstant: 25).isActive = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    galleryDocument?.open { success in
      if success {
        if self.gallery == nil {
          self.gallery = self.galleryDocument!.gallery
          self.gallery.title = self.galleryDocument!.localizedName
        }
      } else {
        // TODO: Present an alert to the user.
      }
    }
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? ImageDisplayViewController {
      let cell = sender as! UICollectionViewCell
      if let indexPath = collectionView?.indexPath(for: cell),
         let selectedImageModel = getImage(at: indexPath) {
        destination.image = cachedImages[selectedImageModel]
      }
    }
  }
  
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    let cell = sender as! UICollectionViewCell
    if let indexPath = collectionView?.indexPath(for: cell),
       let selectedImageModel = getImage(at: indexPath) {
      return cachedImages[selectedImageModel] != nil
    } else {
      return false
    }
  }
  
  // MARK: - Actions
  
  @IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
    guard let maximumItemWidth = maximumItemWidth else { return }
    guard let minimumItemWidth = minimumItemWidth else { return }
    guard itemWidth <= maximumItemWidth else { return }
    
    if sender.state == .began || sender.state == .changed {
      let scaledWidth = itemWidth * sender.scale
      
      if scaledWidth <= maximumItemWidth,
         scaledWidth >= minimumItemWidth {
        itemWidth = scaledWidth
        flowLayout?.invalidateLayout()
      }
      
      sender.scale = 1
    }
  }
  
  @IBAction func didTapDone(_ sender: UIBarButtonItem) {
    galleryDocument?.gallery = gallery
    galleryDocument?.updateChangeCount(.done)
    galleryDocument?.close() { success in
      if success == false {
        // TODO: Present an alert to the user.
      }
      
      self.dismiss(animated: true)
    }
  }
  
  // MARK: - Imperatives
  
  /// Returns the image at the provided indexPath.
  private func getImage(at indexPath: IndexPath) -> ImageGallery.Image? {
    return gallery?.images[indexPath.item]
  }
  
  /// Inserts the provided image at the provided indexPath.
  private func insertImage(_ image: ImageGallery.Image, at indexPath: IndexPath) {
    gallery.images.insert(image, at: indexPath.item)
  }
  
  // MARK: - Collection view data source
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gallery?.images.count ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    guard let galleryImageModel = getImage(at: indexPath) else {
      return cell
    }
    
    if let imageCell = cell as? ImageCollectionViewCell {
      if let image = cachedImages[galleryImageModel] {
        imageCell.imageView.image = image
        imageCell.isLoading = false
      } else {
        imageCell.isLoading = true
        
        // If we don't have an image, request and cache it.
        imageRequestManager?.request(at: galleryImageModel.imagePath!) { data in
          if let loadedImage = UIImage(data: data) {
            DispatchQueue.main.async {
              self.cachedImages[galleryImageModel] = loadedImage
              self.collectionView?.reloadData()
            }
          }
        }
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
    guard gallery != nil else {
      return UICollectionViewDropProposal(operation: .forbidden)
    }
    
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
        var draggedImage = ImageGallery.Image(imagePath: nil, aspectRatio: 1)
        
        // Loads the image.
        // TODO: Check if it's possible to add the placeholder only after figuring out what's the aspect ratio.
        _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){ (provider, error) in
          DispatchQueue.main.async {
            if let image = provider as? UIImage {
              draggedImage.aspectRatio = image.aspectRatio
            }
          }
        }
        
        // Loads the URL.
        _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
          if let url = provider?.imageURL {
            draggedImage.imagePath = url

            self.imageRequestManager?.request(at: url) { data in
              DispatchQueue.main.async {
                if let loadedImage = UIImage(data: data) {
                  placeholderContext.commitInsertion { indexPath in
                    self.cachedImages[draggedImage] = loadedImage
                    self.insertImage(draggedImage, at: indexPath)
                  }
                } else {
                  // There was an error. Remove the placeholder.
                  placeholderContext.deletePlaceholder()
                }
              }
            }

          }
        }
        
      }

    }
  }
  
  // MARK: - UIDropInteraction delegate
  
  func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
    return session.canLoadObjects(ofClass: URL.self)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    return UIDropProposal(operation: .move)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    guard let item = session.items.first else { return }
    guard let droppedImage = item.localObject as? ImageGallery.Image else { return }
    guard let index = gallery.images.index(of: droppedImage) else { return }
    
    gallery.images.remove(at: index)
  }
  
  // MARK: - ImageRequestManager delegate
  
  func didReceiveReponseData(_ data: Data, at url: URL) {}
  
  func didReceiveErrorResponse(_ response: URLResponse) {
    // TODO: Present error to the user.
  }
  
  func didReceiveClientError(_ error: Error) {
    // TODO: Present error to the user.
  }
  
}
