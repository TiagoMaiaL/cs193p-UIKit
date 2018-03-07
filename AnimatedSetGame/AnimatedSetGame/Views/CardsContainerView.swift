//
//  CardsContainerView.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 07/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// A view holding card buttons.
class CardsContainerView: UIView {

  // MARK: Properties
  
  /// The contained card buttons.
  private(set) var buttons = [CardButton]()
  
  /// The grid in charge of generating the calculated
  /// frame of each contained button.
  private(set) var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
  
  /// The rect in which the buttons are going to be positioned,
  /// according to the grid.
  private var gridRect: CGRect {
    get {
      return CGRect(x: bounds.size.width * 0.025,
                    y: bounds.size.height * 0.025,
                    width: bounds.size.width * 0.95,
                    height: bounds.size.height * 0.95)
    }
  }
  
  // MARK: Life cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Only updates the buttons frames if the centered rect has changed,
    // This will occur when orientation changes.
    // This check will prevent frame changes while
    // the animator is doing it's job.
    if grid.frame != gridRect {
      updateViewsFrames()
    }
  }
  
  // MARK: Imperatives
  
  /// Applies the grid frames to all subviews.
  private func updateViewsFrames(withAnimation animated: Bool = false,
                                 andCompletion completion: Optional<() -> ()> = nil) {
    grid.frame = gridRect
    
    if animated {
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          self.respositionViews()
      }
      ) { _ in
        if let completion = completion {
          completion()
        }
      }
    } else {
      respositionViews()
    }
  }
  
  /// Assigns each button's to the corresponding grid's frame.
  private func respositionViews() {
    for (i, button) in self.buttons.enumerated() {
      if let frame = grid[i] {
        button.frame = frame
      }
    }
  }
  
  /// Adds new buttons to the UI.
  /// - Parameter byAmount: The number of buttons to be added.
  /// - Parameter animated: Bool indicating if the addition should be animated.
  func addCardButtons(byAmount numberOfButtons: Int = 3, animated: Bool = false) {
//    guard isPerformingDealAnimation == false else { return }
    
    let cardButtons = (0..<numberOfButtons).map { _ in SetCardButton() }
    
    for button in cardButtons {
      // Each button is hidden and face down by default.
      button.alpha = 0
      button.isFaceUp = false
      
      addSubview(button)
//      buttons.append(button)
    }
    
    grid.cellCount += cardButtons.count
    grid.frame = gridRect
    
//    if animated {
//      animateCardButtonsDeal()
//    }
  }
  
  /// Removes the empty card buttons from the container.
  ///
  /// - Note: The empty card buttons here are the buttons with the
  ///         alpha property equals to zero.
  func removeEmptyCardButtons(withCompletion completion: Optional<() -> ()> = nil) {
    let emptyButtons = buttons.filter { $0.alpha == 0 }
    
    guard emptyButtons.count > 0 else { return }
    
    for button in emptyButtons {
      buttons.remove(at: buttons.index(of: button)!)
      button.removeFromSuperview()
    }
    
    grid.cellCount = buttons.count
    updateViewsFrames(withAnimation: true, andCompletion: completion)
  }
  
  /// Removes all buttons from the container.
  func clearCardContainer(withAnimation animated: Bool = false, completion: Optional<() -> ()> = nil) {
//    if animated {
//      animateCardButtonsOut(buttons)
//    }
    
    buttons.forEach {
      $0.removeFromSuperview()
    }
    buttons = []
    grid.cellCount = 0
    
    setNeedsLayout()
  }

}
