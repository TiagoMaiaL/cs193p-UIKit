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
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: pre-populate the data
    
    galleries = [ImageGallery(images: [], title: "Gallery 1"),
                 ImageGallery(images: [], title: "Gallery 2"),
                 ImageGallery(images: [], title: "Gallery 3"),
    ]
    
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
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
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
