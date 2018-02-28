//
//  CardContainerView.swift
//  GraphicalSetGamee
//
//  Created by Tiago Maia Lopes on 09/02/18.
//  Copyright © 2018 Tiago Maia Lopes. All rights reserved.
//

import UIKit

/// Protocol used to give the superview or controller a
/// chance to act after some card container events.
protocol CardContainerViewDelegate {
  
  /// Method called when the removal animation becomes finished.
  func cardsRemovalDidFinish()
}

/// The view responsible for holding and displaying a grid of cardButtons.
class CardContainerView: UIView {
  
  // MARK: Properties
  
  /// The container's delegate
  var delegate: CardContainerViewDelegate?
  
  /// The translated deck frame used by the dealing animation.
  /// - Note: This frame is the origin and size for all added buttons.
  ///         When the deal animation takes place, all cards will fly from
  ///         this frame to each destination.
  var deckFrame: CGRect!
  
  /// The translated matched deck frame used by the removal animation.
  /// - Note: This frame is the origin and size for all added buttons.
  ///         When the deal animation takes place, all cards will fly from
  ///         this frame to each destination.
  var matchedDeckFrame: CGRect!
  
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
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2,
                                                     delay: 0,
                                                     options: .allowUserInteraction,
                                                     animations: {
                                                      if let frame = self.grid[i] {
                                                        button.frame = frame
                                                      }
      })
    }
  }
  
  // MARK: Imperatives
  
  /// Adds new buttons to the UI.
  /// - Parameter byAmount: The number of buttons to be added.
  /// - Parameter animated: Bool indicating if the addition should be animated.
  func addCardButtons(byAmount numberOfButtons: Int = 3, animated: Bool = false) {
    let cardButtons = (0..<numberOfButtons).map { _ in SetCardButton() }
    
    for button in cardButtons {
      addSubview(button)
      buttons.append(button)
      
      // Each button is hidden by default.
      button.alpha = 0
    }

    grid.cellCount += cardButtons.count
    grid.frame = centeredRect
    
    setNeedsLayout()

    if animated {
      animateCardButtonsDeal()
    }
  }
  
  /// Removes the empty card buttons from the container.
  ///
  /// - Note: The empty card buttons here are the buttons with the
  ///         alpha property equals to zero.
  func removeEmptyCardButtons() {
    let emptyButtons = buttons.filter { $0.alpha == 0 }
    
    for button in emptyButtons {
      buttons.remove(at: buttons.index(of: button)!)
      button.removeFromSuperview()
    }
    
    grid.cellCount = buttons.count
    setNeedsLayout()
  }
  
  /// Animates all empty cards to their original position.
  ///
  /// - Note: The animation is performed by taking a copy of
  ///         each hidden button and animating them from the deck
  ///         to their current position.
  func animateCardButtonsDeal() {
    var dealAnimationDelay = 0.15
    
    // TODO: use DynamicAnimator to deal cards.
    for (i, button) in buttons.enumerated() {
      // If the button isn't empty (hidden) we continue the loop.
      if button.alpha != 0 { continue }
      
      // Creates a button copy.
      let buttonCopy = button.copy() as! SetCardButton
      buttonCopy.frame = deckFrame
      addSubview(buttonCopy)
      
      // Animates the copy to the real button's position.
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: dealAnimationDelay,
        options: .allowUserInteraction,
        animations: {
          if let frame = self.grid[i] {
            buttonCopy.frame = frame
          }
      }) { _ in
        button.alpha = 1
        buttonCopy.removeFromSuperview()
      }
      
      dealAnimationDelay += 0.2
    }
  }
  
  /// Animates the passed buttons out of the table and on
  /// to the pile of matched cards.
  ///
  /// - Note: The animation takes place in three steps:
  ///         * A scale transformation is applied
  ///         * The buttons are concentrated in the center of this view
  ///         * The cards are flipped
  ///         * The cards are put in the matched pile
  func animateMatchedCardButtonsOut(_ buttons: [SetCardButton]) {
    guard matchedDeckFrame != nil else { return }
    
    var buttonsCopies = [SetCardButton]()
    
    for button in buttons {
      // Creates the button copy used to be animated.
      let buttonCopy = button.copy(with: nil) as! SetCardButton
      buttonsCopies.append(buttonCopy)
      addSubview(buttonCopy)
      
      // Hides the original button.
      button.alpha = 0
    }
    
    // Starts animating by scaling each button.
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.1,
      delay: 0,
      options: .curveEaseIn,
      animations: {

        buttonsCopies.forEach { $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) }
        
    }, completion: { position in
      
      // Animates each card to the center of the container view.
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseIn,
        animations: {
          
          buttonsCopies.forEach { $0.center = self.center }
          
      }, completion: { position in
        // Flips each card down
        buttonsCopies.forEach { $0.flipCard() }
        
        // Animates each card to the matched deck.
        UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: 0.2,
          delay: 0.3,
          options: .curveEaseInOut,
          animations: {
            
            buttonsCopies.forEach { $0.frame = self.matchedDeckFrame }
            
        }) { _ in
          // Removes all the copied buttons
          buttonsCopies.forEach { $0.removeFromSuperview() }
          
          // Calls the delegate, if set.
          if let delegate = self.delegate {
            delegate.cardsRemovalDidFinish()
          }
        }
      })
    })
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
