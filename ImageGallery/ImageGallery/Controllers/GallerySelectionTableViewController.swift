//
//  GallerySelectionTableViewController.swift
//  ImageGallery
//
//  Created by Tiago Maia Lopes on 21/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The controller responsible for the selection of galleries.
class GallerySelectionTableViewController: UITableViewController, GallerySelectionTableViewCellDelegate {

  enum Section: Int {
    case available = 0
    case deleted
  }
  
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
        return [store.galleries, store.deletedGalleries]
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
        
        let section = Section(rawValue: indexPath.section)
        guard section == .available else { return }
        
        let selectedGallery = galleriesSource[indexPath.section][indexPath.row]
        
        if let navigationController = segue.destination as? UINavigationController {
          if let displayController = navigationController.visibleViewController as? GalleryDisplayCollectionViewController {
            displayController.gallery = selectedGallery
          }
        }
      }
    }
  }
  
  // MARK: - Actions
  
  @IBAction func didTapAddMore(_ sender: UIBarButtonItem) {
    galleriesStore?.addNewGallery()
  }
  
  @IBAction func didDoubleTap(_ sender: UITapGestureRecognizer) {
    if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
      if let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
        cell.isEditing = true
      }
    }
  }
  
  // MARK: - Imperatives
  
  private func getGallery(at indexPath: IndexPath) -> ImageGallery? {
    return galleriesSource[indexPath.section][indexPath.row]
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
//    print("sections: - \(galleriesSource.count)")
    return galleriesSource.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    print("rows: - \(galleriesSource[section].count) in section: - \(section)")
    return galleriesSource[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell",
                                             for: indexPath)
    
    let gallery = galleriesSource[indexPath.section][indexPath.row]
    if let galleryCell = cell as? GallerySelectionTableViewCell {
      galleryCell.delegate = self
      galleryCell.title = gallery.title
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle {
    case .delete:
      if let deletedGallery = getGallery(at: indexPath) {

        self.galleriesStore?.removeGallery(deletedGallery)
        tableView.reloadData()

        // TODO: Make animations work.
//        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      break

    default:
      break
    }
  }
  
  // MARK: - Table view delegate
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 1 {
      return "Recently Deleted"
    } else {
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let section = Section(rawValue: indexPath.section)
    
    if section == .deleted {
      var actions = [UIContextualAction]()
      
      let recoverAction = UIContextualAction(style: .normal, title: "recover") { (action, view, _) in
        if let deletedGallery = self.getGallery(at: indexPath) {
          self.galleriesStore?.recoverGallery(deletedGallery)
          self.tableView.reloadData()
        }
      }
      
      actions.append(recoverAction)
      return UISwipeActionsConfiguration(actions: actions)
      
    } else {
      return nil
    }
  }
  
  // MARK: - Gallery selection cell delegate
  
  func titleDidChange(_ title: String, in cell: UITableViewCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      if var gallery = getGallery(at: indexPath) {
        gallery.title = title
        galleriesStore?.updateGallery(gallery)
        tableView.reloadData()
      }
    }
  }
  
}
