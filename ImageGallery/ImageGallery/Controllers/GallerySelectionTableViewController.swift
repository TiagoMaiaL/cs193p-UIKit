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
  
  /// The store containing the user's galleries.
  var galleriesStore: ImageGalleryStore? {
    didSet {
      tableView?.reloadData()
      detailController?.gallery = galleriesStore?.galleries.first
    }
  }
  
  /// The table view's data.
  private var galleriesSource: [[ImageGallery]] {
    get {
      if let store = galleriesStore {
        var source = [store.galleries]
        
        if !store.deletedGalleries.isEmpty {
          source.append(store.deletedGalleries)
        }
        
        return source
      } else {
        return []
      }
    }
  }
  
  /// The split's detail controller, if set.
  private var detailController: GalleryDisplayCollectionViewController? {
    return splitViewController?.viewControllers.last?.contents as? GalleryDisplayCollectionViewController
  }
  
  // MARK: - Life cycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
