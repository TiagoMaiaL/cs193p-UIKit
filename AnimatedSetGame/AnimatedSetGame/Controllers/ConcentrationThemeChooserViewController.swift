//
//  ConcentrationThemeChooserViewController.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 23/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

  // MARK: Properties
  
  /// Segue to show the concentration game view controller.
  private let concentrationSegueID = "show concentration"
  
  /// The array of all theme choosing buttons.
  @IBOutlet var themeButtons: [UIButton]!
  
  /// The SplitController's detail controller.
  /// - Note: If the user's device supports the split controller,
  ///         it's possible to get it's detail controller and avoid the segue,
  ///         preserving the game's current state.
  var splitDetailConcentrationController: ConcentrationViewController? {
    return splitViewController?.viewControllers.last as? ConcentrationViewController
  }
  
  /// The last segued view controller.
  /// - Note: Since the segue mechanism always creates a brand new controller,
  ///         the controller is stored to preserve the concentration game's state.
  var lastSeguedToConcentrationController: ConcentrationViewController?
  
  // MARK: Life Cycle

  override func awakeFromNib() {
    splitViewController?.delegate = self
  }

  // MARK: Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let concentrationVC = segue.destination as? ConcentrationViewController {
      if let tappedButton = sender as? UIButton {
        concentrationVC.pickedTheme = getPickedTheme(fromButton: tappedButton)!
        lastSeguedToConcentrationController = concentrationVC
      }
    }
  }
  
  // MARK: Imperatives
  
  /// Gets the theme associated with the passed button.
  func getPickedTheme(fromButton button: UIButton) -> ConcentrationViewController.Theme? {
    if let index = themeButtons.index(of: button) {
      return ConcentrationViewController.Theme(rawValue: index)
    } else {
      return nil
    }
  }
  
  // MARK: Actions
  
  /// Action method called when the user chooses a theme from one of the buttons.
  @IBAction func didTapThemeButton(_ sender: UIButton) {
    guard let theme = getPickedTheme(fromButton: sender) else {
      return
    }
    
    if let concentrationController = splitDetailConcentrationController {
      concentrationController.pickedTheme = theme
    } else if let storedConcentrationController = lastSeguedToConcentrationController {
      storedConcentrationController.pickedTheme = theme
      navigationController?.pushViewController(storedConcentrationController, animated: true)
    } else {
      performSegue(withIdentifier: concentrationSegueID, sender: sender)
    }
  }
 
  // MARK: UISplitViewController Delegate Methods
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    if let concentrationController = secondaryViewController as? ConcentrationViewController {
      if concentrationController.pickedTheme == nil {
        return true
      }
    }
    
    return false
  }
}
