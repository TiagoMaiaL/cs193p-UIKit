//
//  ImageGalleryDocumentBrowserViewController.swift
//  PersistentImageGallery
//
//  Created by Tiago Maia Lopes on 03/04/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit


class ImageGalleryDocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
  
  // MARK: - Properties
  
  /// The template file's url.
  var templateURL: URL?
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    allowsPickingMultipleItems = false
    browserUserInterfaceStyle = .dark
    
    allowsDocumentCreation = false
    
    // Only allows the creation of documents when running on ipad devices.
    if UIDevice.current.userInterfaceIdiom == .pad {

      // Creates the template file:
      let fileManager = FileManager.default
      
      templateURL = try? fileManager.url(
        for: .applicationSupportDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
        ).appendingPathComponent("untitled.imagegallery")
      
      if let templateURL = templateURL {
        allowsDocumentCreation = fileManager.createFile(atPath: templateURL.path, contents: Data())
        
        // Writes an empty image gallery into the template file:
        let emptyGallery = ImageGallery(images: [], title: "untitled")
        _ = try? JSONEncoder().encode(emptyGallery).write(to: templateURL)
      }
    }
  }
  
  // MARK: UIDocumentBrowserViewControllerDelegate
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
    importHandler(templateURL, .copy)
  }
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
    guard let sourceURL = documentURLs.first else { return }
    presentDocument(at: sourceURL)
  }
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
    presentDocument(at: destinationURL)
  }
  
  func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
    presentWarningWith(title: "Error", message: "The document can't be opened")
  }
  
  // MARK: Document Presentation
  
  /// Presents the document stored at the provided url.
  func presentDocument(at documentURL: URL) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let navigationViewController = storyBoard.instantiateViewController(withIdentifier: "GalleryViewerNavigationController")
    let documentViewController = navigationViewController.contents as! GalleryDisplayCollectionViewController
    documentViewController.galleryDocument = ImageGalleryDocument(fileURL: documentURL)
    documentViewController.imageRequestManager = ImageRequestManager()
    
    present(navigationViewController, animated: true, completion: nil)
  }
}

