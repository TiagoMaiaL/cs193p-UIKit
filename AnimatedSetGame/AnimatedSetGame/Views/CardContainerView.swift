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
class CardContainerView: UIView, UIDynamicAnimatorDelegate {
  
  // MARK: Properties
  
  /// The container's delegate
  var delegate: CardContainerViewDelegate?
  
  /// The translated deck frame used by the dealing animation.
  /// - Note: This frame is the origin and size for all added buttons.
  ///         When the deal animation takes place, all cards will fly from
  ///         this frame to each destination.
  var deckFrame: CGRect!
  
  /// The translated matched deck frame used by the removal animation.
  /// - Note: When the removal animation takes place, all cards will fly from
  ///         their current position to this frame.
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
  
  /// The animator object responsible for each button's animations.
  lazy private var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
  
  // MARK: Initializer
  
  override func awakeFromNib() {
    animator.delegate = self
  }
  
  // MARK: View life cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // Only updates the buttons frames, if the centered rect has changed,
    // This will occur when orientation changes.
    // This check will prevent frame changes while
    // the animator is doing it's job.
    if grid.frame != centeredRect {
      updateViewsFrames()
    }
  }
  
  // MARK: Imperatives
  
  /// Applies the grid frames to all subviews.
  private func updateViewsFrames(withAnimation animated: Bool = false,
                                 andCompletion completion: Optional<() -> ()> = nil) {
    self.grid.frame = self.centeredRect
    
    /// Assigns each button's frame to the corresponding grid one.
    func respositionViews() {
      for (i, button) in self.buttons.enumerated() {
        if let frame = self.grid[i] {
          button.frame = frame
        }
      }
    }
    
    if animated {
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseInOut,
        animations: {
          respositionViews()
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
  
  /// Adds new buttons to the UI.
  /// - Parameter byAmount: The number of buttons to be added.
  /// - Parameter animated: Bool indicating if the addition should be animated.
  func addCardButtons(byAmount numberOfButtons: Int = 3, animated: Bool = false) {
    let cardButtons = (0..<numberOfButtons).map { _ in SetCardButton() }
    
    for button in cardButtons {
      // Each button is hidden and face down by default.
      button.alpha = 0
      button.isFaceUp = false

      addSubview(button)
      buttons.append(button)
    }
    
    grid.cellCount += cardButtons.count
    grid.frame = centeredRect
    
    animateCardButtonsDeal()
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
    // TODO: Only enable this deal animation when the animator is paused.
    animator.removeAllBehaviors()

    updateViewsFrames(withAnimation: true) {
      var dealAnimationDelay = 0.15
      
      for (i, button) in self.buttons.enumerated() {
        // The deal animation is applied only to the hidden buttons.
        if button.alpha != 0 { continue }
        
        guard let currentFrame = self.grid[i] else { continue }
        
        button.isFaceUp = false
        // Change the position and size to match the provided deck's frame.
        button.frame = self.deckFrame
        // The card will appear on top of the deck.
        button.alpha = 1
        
        let snapBehavior = UISnapBehavior(item: button,
                                          snapTo: currentFrame.center)
        snapBehavior.damping = 0.8
        
        Timer.scheduledTimer(withTimeInterval: dealAnimationDelay, repeats: false) { _ in
          self.animator.addBehavior(snapBehavior)
          
          UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
              button.bounds.size = currentFrame.size
            }
          )
          
          Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
            button.flipCard()
          }
        }
        
        dealAnimationDelay += 0.2
      }
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

        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
          buttonsCopies.forEach { button in
            let snapOutBehavior = UISnapBehavior(item: button, snapTo: self.matchedDeckFrame.center)
            snapOutBehavior.damping = 0.8
            self.animator.addBehavior(snapOutBehavior)
            
            UIViewPropertyAnimator.runningPropertyAnimator(
              withDuration: 0.2,
              delay: 0,
              options: .curveEaseIn,
              animations: {
                button.bounds.size = self.matchedDeckFrame.size
              }
            )
          }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
          buttonsCopies.forEach { $0.removeFromSuperview() }
          
          // Calls the delegate, if set.
          if let delegate = self.delegate {
            delegate.cardsRemovalDidFinish()
          }
        }
        
//        UIViewPropertyAnimator.runningPropertyAnimator(
//          withDuration: 0.2,
//          delay: 0.3,
//          options: .curveEaseInOut,
//          animations: {
//
//            buttonsCopies.forEach { $0.frame = self.matchedDeckFrame }
//
//        }) { _ in
//          // Removes all the copied buttons
//          buttonsCopies.forEach { $0.removeFromSuperview() }
//
//          // Calls the delegate, if set.
//          if let delegate = self.delegate {
//            delegate.cardsRemovalDidFinish()
//          }
//        }
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
  
  // MARK: UIDynamicAnimator Delegate methods
  
  func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
    animator.removeAllBehaviors()
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

extension CGRect {
  
  /// Returns the center of this rect.
  var center: CGPoint {
    return CGPoint(
      x: origin.x + size.width / 2,
      y: origin.y + size.height / 2
    )
  }
  
}
