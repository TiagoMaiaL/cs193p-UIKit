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
  
  /// The grid in charge of generating the calculated
  /// frame of each contained button.
  private(set) var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
  
  /// The centered rect in which the buttons are going to be positioned.
  private var centeredRect: CGRect {
    get {
      return CGRect(x: bounds.size.width * 0.025,
                    y: bounds.size.height * 0.025,
                    width: bounds.size.width * 0.95,
                    height: bounds.size.height * 0.95)
    }
  }

  // MARK: View life cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()

    grid.frame = centeredRect

    for (i, button) in buttons.enumerated() {
      if let frame = grid[i] {
        button.frame = frame
      }
    }
  }
  
  // MARK: Imperatives
  
  /// Adds new buttons to the UI.
  /// - Parameter byAmount: The number of buttons to be added.
  func addCardButtons(byAmount numberOfButtons: Int = 3) {
    let cardButtons = (0..<numberOfButtons).map { _ in SetCardButton() }
    
    for button in cardButtons {
      addSubview(button)
    }
    
    buttons += cardButtons
    
    grid.cellCount = buttons.count
    
    setNeedsLayout()
  }
  
  /// Removes n buttons from the button container.
  func removeCardButtons(byAmount numberOfCards: Int) {
    guard buttons.count >= numberOfCards else { return }
  
    for index in 0..<numberOfCards {
      let button = buttons[index]
      button.removeFromSuperview()
    }
    
    buttons.removeSubrange(0..<numberOfCards)
    grid.cellCount = buttons.count
    
    setNeedsLayout()
  }
  
  /// Removes all buttons from the container.
  func clearCardContainer() {
    buttons = []
    grid.cellCount = 0
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
