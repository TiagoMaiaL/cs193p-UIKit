//
//  CardContainerView.swift
//  GraphicalSetGamee
//
//  Created by Tiago Maia Lopes on 09/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// The view responsible for holding and displaying the cardButtons.
class CardContainerView: UIView {
  
  // MARK: Properties
  
  /// The contained buttons.
  private(set) var buttons = [SetCardButton]()

  // MARK: View life cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()

    // TODO: apply the grid mechanism.
    
  }
  
  // MARK: Imperatives
  
  /// Adds new buttons to the UI.
  /// - Parameter byAmount: The number of buttons to be added.
  func addCardButtons(byAmount numberOfButtons: Int = 3) {
    let cardButtons = (0..<numberOfButtons).map { _ in SetCardButton() }
    
    for button in cardButtons {
      button.frame = CGRect(x: 0, y: 0, width: 50, height: 100)
      button.backgroundColor = .black
      addSubview(button)
    }
    
    buttons += cardButtons
    
    setNeedsLayout()
  }
  
  /// Removes all buttons from the container.
  func clearCardContainer() {
    buttons = []
    removeAllSubviews()
    setNeedsLayout()
  }

}

extension UIView {
  
  /// Removes all subviews.
  func removeAllSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
  
}
