//
//  CardsContainerView.swift
//  AnimatedSetGamee
//
//  Created by Tiago Maia Lopes on 07/03/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// Protocol used to give the superview or controller a
/// chance to act after some card container events.
protocol CardsContainerViewDelegate {
  
  /// Method called when the removal animation becomes finished.
  func cardsRemovalDidFinish()
}

/// A view holding card buttons.
class CardsContainerView: UIView {

  // MARK: Properties
  
  /// The container's delegate
  var delegate: CardsContainerViewDelegate?
  
  /// The contained card buttons.
  var buttons = [CardButton]()
  
  /// The grid in charge of generating the calculated
  /// frame of each contained button.
  var grid = Grid(layout: Grid.Layout.aspectRatio(3/2))
  
  /// The rect in which the buttons are going to be positioned,
  /// according to the grid.
  var gridRect: CGRect {
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
  func updateViewsFrames(withAnimation animated: Bool = false,
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
  func respositionViews() {
    for (i, button) in buttons.filter({ $0.isActive }).enumerated() {
      if let frame = grid[i] {
        button.frame = frame
      }
    }
  }
  
  /// Removes the inactive card buttons from the container.
  func removeInactiveCardButtons(withCompletion completion: Optional<() -> ()> = nil) {
    let inactiveButtons = buttons.filter { !$0.isActive }
    
    guard inactiveButtons.count > 0 else { return }
    
    for button in inactiveButtons {
      buttons.remove(at: buttons.index(of: button)!)
      button.removeFromSuperview()
    }
    
    grid.cellCount = buttons.count
    updateViewsFrames(withAnimation: true, andCompletion: completion)
  }
  
  /// Removes all buttons from the container.
  func clearCardContainer(withAnimation animated: Bool = false, completion: Optional<() -> ()> = nil) {
    if animated {
      animateCardsOut(buttons)
    }
    
    buttons.forEach {
      $0.removeFromSuperview()
    }
    buttons = []
    grid.cellCount = 0
    
    setNeedsLayout()
  }
  
  /// Animates the passed buttons out of the container.
  func animateCardsOut(_ buttons: [CardButton]) {}

}

extension UIView {
  
  /// Removes all subviews.
  func removeAllSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
  
}

extension CGRect {
  
  /// Returns the center of this rect.
  var center: CGPoint {
    return CGPoint(
      x: midX,
      y: midY
    )
  }
  
}
