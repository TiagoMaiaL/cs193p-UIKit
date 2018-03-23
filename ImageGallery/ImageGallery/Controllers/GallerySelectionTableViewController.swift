//
//  GallerySelectionTableViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The controller responsible for the selection of galleries.
class GallerySelectionTableViewController: UITableViewController {

  // MARK: Properties
  
  /// The galleries for display.
  private var galleries = [ImageGallery]()
  
  /// The deleted galleries.
  private var deletedGalleries = [ImageGallery]()
  
  /// The table view's data.
  private var galleriesSource: [[ImageGallery]] {
    get {
      var source = [galleries]
      
      if !deletedGalleries.isEmpty {
        source.append(deletedGalleries)
      }
      
      return source
    }
  }
  
  /// The split's detail controller, if set.
  private var detailController: GalleryDisplayCollectionViewController? {
    return splitViewController?.viewControllers.last?.contents as? GalleryDisplayCollectionViewController
  }
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    galleries = [ImageGallery(images: [], title: "Gallery 1"),
                 ImageGallery(images: [], title: "Gallery 2"),
                 ImageGallery(images: [], title: "Gallery 3"),
    ]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    detailController?.gallery = galleries.first
  }
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let selectedCell = sender as? UITableViewCell {
      if let indexPath = tableView.indexPath(for: selectedCell) {
        
        let selectedGallery = galleriesSource[indexPath.section][indexPath.row]
        
        if let navigationController = segue.destination as? UINavigationController {
          if let displayController = navigationController.visibleViewController as? GalleryDisplayCollectionViewController {
            displayController.gallery = selectedGallery
          }
        }
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return galleriesSource.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return galleriesSource[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell",
                                             for: indexPath)
    
    let gallery = galleriesSource[indexPath.section][indexPath.row]
    cell.textLabel?.text = gallery.title
    
    return cell
  }

  
}
